
import bodyParser from "body-parser";
import express from "express";
import serverless from "serverless-http";

export const app = express();

// Parse incoming request body
app.use(bodyParser.json());

// API routes
app.get('/', function (req, res) {
  res.send('hello world')
})

// Wrap app in serverless-http
export const serverlessApp = serverless(app);

export default serverlessApp;
