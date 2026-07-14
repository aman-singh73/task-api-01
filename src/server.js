const express = require('express');
const { PrismaClient } = require('@prisma/client');
const cors = require('cors');
const path = require('path');
require('dotenv').config();

const app = express();
const prisma = new PrismaClient();
const PORT = process.env.PORT || 5000;

app.use(cors());
app.use(express.json());

// Serve static frontend files from 'src/public'
app.use(express.static(path.join(__dirname, 'public')));

// GET /tasks - List all tasks ordered by creation date descending
app.get('/tasks', async (req, res) => {
  try {
    const tasks = await prisma.task.findMany({
      orderBy: {
        createdAt: 'desc',
      },
    });
    res.json(tasks);
  } catch (error) {
    console.error('Error fetching tasks:', error);
    res.status(500).json({ error: 'Internal Server Error' });
  }
});

// POST /tasks - Create a new task
app.post('/tasks', async (req, res) => {
  const { title, description } = req.body;
  if (!title || typeof title !== 'string' || title.trim() === '') {
    return res.status(400).json({ error: 'Title is required' });
  }
  try {
    const task = await prisma.task.create({
      data: {
        title: title.trim(),
        description: description ? description.trim() : null,
      },
    });
    res.status(201).json(task);
  } catch (error) {
    console.error('Error creating task:', error);
    res.status(500).json({ error: 'Internal Server Error' });
  }
});

// DELETE /tasks/:id - Delete a task by ID
app.delete('/tasks/:id', async (req, res) => {
  const id = parseInt(req.params.id, 10);
  if (isNaN(id)) {
    return res.status(400).json({ error: 'Invalid ID' });
  }
  try {
    await prisma.task.delete({
      where: { id },
    });
    res.json({ message: 'Task deleted successfully' });
  } catch (error) {
    console.error('Error deleting task:', error);
    if (error.code === 'P2025') {
      return res.status(404).json({ error: 'Task not found' });
    }
    res.status(500).json({ error: 'Internal Server Error' });
  }
});

// PATCH /tasks/:id - Toggle/update a task
app.patch('/tasks/:id', async (req, res) => {
  const id = parseInt(req.params.id, 10);
  if (isNaN(id)) {
    return res.status(400).json({ error: 'Invalid ID' });
  }
  const { title, description, completed } = req.body;
  const updateData = {};
  if (title !== undefined) updateData.title = title.trim();
  if (description !== undefined) updateData.description = description ? description.trim() : null;
  if (completed !== undefined) updateData.completed = !!completed;

  try {
    const task = await prisma.task.update({
      where: { id },
      data: updateData,
    });
    res.json(task);
  } catch (error) {
    console.error('Error updating task:', error);
    if (error.code === 'P2025') {
      return res.status(404).json({ error: 'Task not found' });
    }
    res.status(500).json({ error: 'Internal Server Error' });
  }
});

// Fallback to index.html for single page application routing
app.get('*', (req, res) => {
  res.sendFile(path.join(__dirname, 'public', 'index.html'));
});

// Start the server
const server = app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});

// Handle graceful shutdown
process.on('SIGINT', async () => {
  await prisma.$disconnect();
  server.close(() => {
    console.log('Server process terminated');
    process.exit(0);
  });
});
