# System Architecture

                    Users
                      │
                      ▼
             React Frontend (Vite)
                      │
                      ▼
              Express REST API
                      │
                      ▼
              JWT Authentication
                      │
                      ▼
                MongoDB Atlas
                      ▲
# Docker to AWS

              Docker Desktop Image
                      │
                      ▼
               Docker Hub Image
                      │
                      ▼
               AWS EC2 Instance
                      │
                      ▼
               Elastic IP Address
                      │
                      ▼
               Run Docker Container
                      │
                      ▼
                Internet Access
