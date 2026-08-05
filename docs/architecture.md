# System Architecture

                    Users
                      │
                      ▼
            React Frontend (Vite)
                      │
                      ▼
             Express REST API
                      │
            JWT Authentication
                      │
                      ▼
              MongoDB Atlas
                      ▲
                      │
─────────────────────────────────────────────
               Docker Container
                      │
               Docker Hub Image
                      │
                AWS EC2 Instance
                      │
               Elastic IP Address
                      │
                Internet Access
