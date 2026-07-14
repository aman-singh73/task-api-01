document.addEventListener('DOMContentLoaded', () => {
  const taskForm = document.getElementById('task-form');
  const taskTitle = document.getElementById('task-title');
  const taskDesc = document.getElementById('task-desc');
  const tasksList = document.getElementById('tasks-list');
  const loadingState = document.getElementById('loading');
  const emptyState = document.getElementById('empty-state');
  const tasksCountBadge = document.getElementById('tasks-count');
  
  const statTotal = document.querySelector('#stat-total .stat-num');
  const statPending = document.querySelector('#stat-pending .stat-num');
  const statCompleted = document.querySelector('#stat-completed .stat-num');

  const API_URL = '/tasks';
  let tasks = [];

  // Fetch tasks on initial load
  fetchTasks();

  // Handle Form Submission
  taskForm.addEventListener('submit', async (e) => {
    e.preventDefault();
    const title = taskTitle.value.trim();
    const description = taskDesc.value.trim();

    if (!title) return;

    try {
      const response = await fetch(API_URL, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ title, description }),
      });

      if (!response.ok) {
        throw new Error('Failed to create task');
      }

      const newTask = await response.json();
      tasks.unshift(newTask); // Add to the top of list
      renderTasks();
      
      // Reset Form
      taskForm.reset();
    } catch (error) {
      console.error('Error creating task:', error);
      alert('Error creating task. Please try again.');
    }
  });

  // Fetch all tasks from Server
  async function fetchTasks() {
    showLoading(true);
    try {
      const response = await fetch(API_URL);
      if (!response.ok) {
        throw new Error('Failed to fetch tasks');
      }
      tasks = await response.json();
      renderTasks();
    } catch (error) {
      console.error('Error fetching tasks:', error);
      tasksList.innerHTML = `<p class="error-message" style="color: var(--danger); text-align: center;">Failed to load tasks. Verify backend database setup.</p>`;
    } finally {
      showLoading(false);
    }
  }

  // Render task list and update stats
  function renderTasks() {
    tasksList.innerHTML = '';
    
    if (tasks.length === 0) {
      emptyState.classList.remove('hidden');
      tasksCountBadge.textContent = '0';
      updateStats();
      return;
    }

    emptyState.classList.add('hidden');
    tasksCountBadge.textContent = tasks.length;

    tasks.forEach(task => {
      const taskEl = createTaskDOMElement(task);
      tasksList.appendChild(taskEl);
    });

    updateStats();
  }

  // Helper to create HTML element for each task
  function createTaskDOMElement(task) {
    const div = document.createElement('div');
    div.className = `task-item ${task.completed ? 'completed' : ''}`;
    div.dataset.id = task.id;

    div.innerHTML = `
      <label class="task-checkbox-container">
        <input type="checkbox" class="task-checkbox" ${task.completed ? 'checked' : ''}>
      </label>
      <div class="task-content">
        <h3 class="task-item-title">${escapeHTML(task.title)}</h3>
        ${task.description ? `<p class="task-item-desc">${escapeHTML(task.description)}</p>` : ''}
      </div>
      <button class="btn-delete" title="Delete Task">
        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="3 6 5 6 21 6"></polyline><path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"></path><line x1="10" y1="11" x2="10" y2="17"></line><line x1="14" y1="11" x2="14" y2="17"></line></svg>
      </button>
    `;

    // Toggle complete on checkbox change
    const checkbox = div.querySelector('.task-checkbox');
    checkbox.addEventListener('change', () => toggleTaskComplete(task.id, checkbox.checked));

    // Delete task on click
    const deleteBtn = div.querySelector('.btn-delete');
    deleteBtn.addEventListener('click', () => deleteTask(task.id, div));

    return div;
  }

  // Toggle Task Completion State on DB and UI
  async function toggleTaskComplete(id, completed) {
    try {
      const response = await fetch(`${API_URL}/${id}`, {
        method: 'PATCH',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ completed }),
      });

      if (!response.ok) {
        throw new Error('Failed to update task status');
      }

      const updatedTask = await response.json();
      
      // Update local state
      const taskIndex = tasks.findIndex(t => t.id === id);
      if (taskIndex !== -1) {
        tasks[taskIndex] = updatedTask;
      }

      // Find DOM element and toggle completed style class
      const taskEl = tasksList.querySelector(`[data-id="${id}"]`);
      if (taskEl) {
        if (completed) {
          taskEl.classList.add('completed');
        } else {
          taskEl.classList.remove('completed');
        }
      }

      updateStats();
    } catch (error) {
      console.error('Error toggling task complete:', error);
      alert('Error updating task. Please try again.');
      // Revert checkbox state
      fetchTasks();
    }
  }

  // Delete Task on DB and UI with animation
  async function deleteTask(id, element) {
    try {
      element.classList.add('fade-out');
      
      // Wait for fade-out animation to complete
      await new Promise(resolve => setTimeout(resolve, 250));

      const response = await fetch(`${API_URL}/${id}`, {
        method: 'DELETE',
      });

      if (!response.ok) {
        throw new Error('Failed to delete task');
      }

      // Update local state and re-render
      tasks = tasks.filter(t => t.id !== id);
      renderTasks();
    } catch (error) {
      console.error('Error deleting task:', error);
      alert('Error deleting task. Please try again.');
      fetchTasks();
    }
  }

  // Update Stats Dashboard Counters
  function updateStats() {
    const total = tasks.length;
    const completed = tasks.filter(t => t.completed).length;
    const pending = total - completed;

    statTotal.textContent = total;
    statPending.textContent = pending;
    statCompleted.textContent = completed;
  }

  // Show/Hide Loading Spinner
  function showLoading(show) {
    if (show) {
      loadingState.classList.remove('hidden');
    } else {
      loadingState.classList.add('hidden');
    }
  }

  // Utility to prevent XSS
  function escapeHTML(str) {
    return str.replace(/[&<>'"]/g, 
      tag => ({
        '&': '&amp;',
        '<': '&lt;',
        '>': '&gt;',
        "'": '&#39;',
        '"': '&quot;'
      }[tag] || tag)
    );
  }
});
