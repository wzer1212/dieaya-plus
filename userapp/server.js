const express = require('express');
const path = require('path');
const app = express();

// Serve static files from the "web" directory (your Flutter build output)
app.use(express.static(path.join(__dirname, 'web')));

// Route for the index.html
app.get('/', (req, res) => {
  res.sendFile(path.join(__dirname, 'web', 'index.html'));
});

// Start the server on port 8000 (or any other port you prefer)
const port = 8000;
app.listen(port, () => {
  console.log(`Server is running at http://localhost:${port}`);
});
