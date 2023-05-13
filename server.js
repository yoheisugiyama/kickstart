//look at  https://github.com/fridays/next-routes for details

const {createServer} = require('http');
const next =require ('next');

// by this code next.js is going to figure out whether the app is in production mode or development mode, etc.

const app = next({
    dev: process.env.NODE_ENV !== 'production'
});

const routes = require('./routes');
const handler = routes.getRequestHandler(app);

app.prepare().then(()=>{
    createServer(handler).listen(3000,(err)=> {
        if (err) throw err;
        console.log('Ready on localhost:3000');
    });
});