# This Is Readme file for instructions.
## How to Clone and Run the `simple-go-webapp` Project Locally?

## Prerequisites

Before running the project, ensure that you have the following installed:

- **Go Programming Language** (version 1.16 or later): [Download Go](https://golang.org/dl/)
- **Git**: [Install Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
### Steps:
## 1. Clone the Repository

First, clone the `simple-go-webapp` repository to your local machine.

```bash
git clone https://github.com/engineerbishnu/simple-go-webapp.git
cd simple-go-webapp
```
Note: Replace your-username with the actual GitHub username or repository path if needed.


## 2. Install Dependencies
Run the following command to install dependencies (if any):

```bash
go mod tidy
```
This command will download and install any Go dependencies listed in the go.mod file.

## 3. Run the Application
To start the Go web server, use the go run command:

```bash
go run main.go
```
Once the server is running, you should see the message:
Starting server on :8080...


## 4. Access the Web Application
Open your web browser and go to:
http://localhost:8080

You should see the static index.html page served by the Go application.

## 5. Stop the Server
To stop the server, press Ctrl + C in the terminal where the server is running.
That's it! You've successfully cloned and run the simple-go-webapp project locally.

### Notes: If you want to dockerize the code then you can use dockerfile which is available here.

---
