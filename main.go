package main

import (
	"html/template"
	"log"
	"net/http"
)

// Define the page structure
type PageData struct {
	Title   string
	Message string
}

// Middleware to log HTTP requests
func logRequest(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		log.Printf("Received request: %s %s", r.Method, r.URL.Path)
		next.ServeHTTP(w, r) // Call the next handler
	})
}

func handler(w http.ResponseWriter, r *http.Request) {
	// Create a data structure to pass to the HTML template
	pageData := PageData{
		Title:   "Welcome to DevOps Learning",
		Message: "Hello DevOps Learner. Let's Start Learn DevOps!",
	}

	// Parse and execute the template
	tmpl, err := template.New("homepage").Parse(`
<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>{{.Title}}</title>
	<style>
		body {
			font-family: Arial, sans-serif;
			background-color: #3498db;
			color: white;
			margin: 0;
			padding: 0;
		}
		.container {
			text-align: center;
			padding: 50px;
		}
		h1 {
			font-size: 2.5em;
			color: #f39c12;
		}
		p {
			font-size: 1.2em;
			margin: 20px 0;
		}
		.button {
			background-color: #e74c3c;
			color: white;
			padding: 10px 20px;
			text-decoration: none;
			border-radius: 5px;
			font-size: 1.1em;
		}
		.footer {
			position: fixed;
			bottom: 0;
			width: 100%;
			background-color: #2c3e50;
			text-align: center;
			padding: 10px;
		}
		footer a {
			color: #ecf0f1;
			text-decoration: none;
			font-weight: bold;
		}
	</style>
</head>
<body>
	<div class="container">
		<h1>{{.Message}}</h1>
		<p>Welcome to your DevOps Learning journey. Let's start building!</p>
		<a href="#contact" class="button">Let's Connect</a>
	</div>
	<div class="footer">
		<p>Contact us: <a href="mailto:devops@learn.com">devops@learn.com</a></p>
	</div>
</body>
</html>
`)

	// Check if template parsing failed
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	// Execute the template, passing the pageData to fill in dynamic values
	err = tmpl.Execute(w, pageData)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
	}
}

func main() {
	// Create a new ServeMux (HTTP request multiplexer)
	mux := http.NewServeMux()

	// Register the handler with the multiplexer
	mux.HandleFunc("/", handler)

	// Apply the middleware by wrapping the ServeMux
	loggedMux := logRequest(mux)

	// Log that the server is running
	log.Println("Server started on http://localhost:8080")

	// Start the server on port 8080, passing in the wrapped mux
	log.Fatal(http.ListenAndServe(":8080", loggedMux))
}
