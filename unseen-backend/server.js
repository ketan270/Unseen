const express = require('express');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const cors = require('cors');

const app = express();
app.use(express.json());
app.use(cors());

// In-memory user storage (replace with database in production)
const users = [];

// Secret key for JWT (use environment variable in production)
const JWT_SECRET = process.env.JWT_SECRET || 'unseen-app-secret-key-change-in-production';

// Health check endpoint
app.get('/', (req, res) => {
    res.json({
        status: 'ok',
        message: 'Unseen API is running',
        endpoints: ['/auth/signup', '/auth/login', '/auth/validate']
    });
});

// Signup endpoint
app.post('/auth/signup', async (req, res) => {
    try {
        const { name, email, password } = req.body;

        // Validate input
        if (!name || !email || !password) {
            return res.status(400).json({ message: 'Name, email, and password are required' });
        }

        // Check if user already exists
        if (users.find(u => u.email === email)) {
            return res.status(400).json({ message: 'User already exists with this email' });
        }

        // Hash password
        const hashedPassword = await bcrypt.hash(password, 10);

        // Create user
        const user = {
            id: Date.now().toString(),
            name,
            email,
            password: hashedPassword,
            authProvider: 'email',
            createdAt: new Date().toISOString()
        };

        users.push(user);

        // Create JWT token
        const token = jwt.sign({ userId: user.id }, JWT_SECRET, { expiresIn: '30d' });

        // Return response (don't send password)
        res.status(201).json({
            user: {
                id: user.id,
                email: user.email,
                name: user.name,
                authProvider: user.authProvider,
                createdAt: user.createdAt
            },
            token
        });
    } catch (error) {
        console.error('Signup error:', error);
        res.status(500).json({ message: 'Server error during signup' });
    }
});

// Login endpoint
app.post('/auth/login', async (req, res) => {
    try {
        const { email, password } = req.body;

        // Validate input
        if (!email || !password) {
            return res.status(400).json({ message: 'Email and password are required' });
        }

        // Find user
        const user = users.find(u => u.email === email);
        if (!user) {
            return res.status(401).json({ message: 'Invalid email or password' });
        }

        // Check password
        const validPassword = await bcrypt.compare(password, user.password);
        if (!validPassword) {
            return res.status(401).json({ message: 'Invalid email or password' });
        }

        // Create JWT token
        const token = jwt.sign({ userId: user.id }, JWT_SECRET, { expiresIn: '30d' });

        // Return response (don't send password)
        res.json({
            user: {
                id: user.id,
                email: user.email,
                name: user.name,
                authProvider: user.authProvider,
                createdAt: user.createdAt
            },
            token
        });
    } catch (error) {
        console.error('Login error:', error);
        res.status(500).json({ message: 'Server error during login' });
    }
});

// Validate session endpoint
app.get('/auth/validate', (req, res) => {
    try {
        // Get token from Authorization header
        const authHeader = req.headers.authorization;
        if (!authHeader || !authHeader.startsWith('Bearer ')) {
            return res.status(401).json({ message: 'No token provided' });
        }

        const token = authHeader.substring(7);

        // Verify token
        const decoded = jwt.verify(token, JWT_SECRET);

        // Find user
        const user = users.find(u => u.id === decoded.userId);
        if (!user) {
            return res.status(401).json({ message: 'User not found' });
        }

        // Return user (don't send password)
        res.json({
            id: user.id,
            email: user.email,
            name: user.name,
            authProvider: user.authProvider,
            createdAt: user.createdAt
        });
    } catch (error) {
        console.error('Validation error:', error);
        res.status(401).json({ message: 'Invalid or expired token' });
    }
});

// Start server
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
    console.log(`🚀 Unseen API server running on port ${PORT}`);
    console.log(`📝 Endpoints available:`);
    console.log(`   POST /auth/signup`);
    console.log(`   POST /auth/login`);
    console.log(`   GET  /auth/validate`);
});
