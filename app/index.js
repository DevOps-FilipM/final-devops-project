const express = require('express');
const app = express();
app.use(express.json());
app.use(express.static('public'));

const PORT = process.env.PORT || 3000;
let todos = [];
let nextId = 1;

app.get('/health', (req, res) => {
  res.json({ status: 'OK', timestamp: new Date() });
});

app.get('/todos', (req, res) => {
  res.json(todos);
});

app.post('/todos', (req, res) => {
  const todo = { id: nextId++, title: req.body.title, done: false };
  todos.push(todo);
  res.status(201).json(todo);
});

app.put('/todos/:id', (req, res) => {
  const todo = todos.find(t => t.id === parseInt(req.params.id));
  if (!todo) return res.status(404).json({ error: 'Not found' });
  todo.done = !todo.done;
  res.json(todo);
});

app.delete('/todos/:id', (req, res) => {
  todos = todos.filter(t => t.id !== parseInt(req.params.id));
  res.json({ message: 'Deleted' });
});

app.get('/api', (req, res) => {
  res.json({
    name: 'Todo App API',
    version: '1.0.1',
    description: 'Simple Todo App for DevOps project',
    author: 'fmagiera',
    endpoints: {
      health: 'GET /health',
      todos: 'GET /todos',
      create: 'POST /todos',
      update: 'PUT /todos/:id',
      delete: 'DELETE /todos/:id'
    },
    monitoring: {
      prometheus: 'http://' + (process.env.HOST || 'localhost') + ':9090',
      grafana: 'http://' + (process.env.HOST || 'localhost') + ':3001'
    }
  });
});

app.listen(PORT, () => {
  console.log(`Todo app running on port ${PORT}`);
});
