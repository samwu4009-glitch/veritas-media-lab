# Veritas Media Lab

A multilingual AI-assisted news verification and media-literacy website. The interface and assets are served by Flask; analysis, Ask, live news and visitor history use the Flask API.

## Features

- Truth Lab analyzes checkable claims with SIFT and PIE guidance, live news search, source links and an uncertainty-aware report.
- - Ask provides a multilingual Q&A panel.
  - - Live homepage news from UN News and Toutiao, with source status and refresh controls.
    - - Anonymous browser-linked analysis and chat history, with export and delete controls.
      - - Offline speech-to-text through a locally cached faster-whisper model. Browser recordings are sent only to this Flask service.
        - - Simplified Chinese, Traditional Chinese and English UI; audio-guided tour, responsive layout and report export/share tools.
         
          - ## Local run
         
          - ```sh
            python3 -m venv .venv
            source .venv/bin/activate
            pip install -r requirements.txt
            cp .env.example .env  # add your API key to .env
            python3 -m flask --app app init-db
            python3 -m flask --app app run
            ```

            Open the Flask URL printed in the terminal. Do not open `index.html` directly; the website requires the Flask API. Set `DATABASE_URL` to PostgreSQL for a PostgreSQL database; otherwise local development uses SQLite under `instance/`.

            ## Deploy on Render (free trial)

            This repository includes `render.yaml` and a Dockerfile. Render runs the Flask backend and PostgreSQL; GitHub Pages alone cannot run these backend features.

            1. In Render, choose **New → Blueprint** and connect `samwu4009-glitch/veritas-media-lab`.
            2. 2. Review the blueprint. It creates one free Docker web service and one free PostgreSQL database.
               3. 3. In the web service environment settings, set `DEEPSEEK_API_KEY` directly in Render. Never commit a real key or put it in browser code.
                  4. 4. Wait for `/api/health` to pass, then open the Render-provided `onrender.com` URL. First speech transcription downloads the Whisper model and may take longer.
                    
                     5. Free services may sleep; local files and downloaded models are not persistent, and free database capacity/retention is limited. Check the current limits in Render. The SQLite database on the developer computer is not migrated; the hosted database starts empty. Upgrade to persistent services and arrange a secure migration for long-term storage.
                    
                     6. ## Privacy and security
                    
                     7. - `.env`, local SQLite data and Python virtual environments are excluded from Git. Do not upload API keys, credentials or private visitor history.
                        - - Truth Lab and Ask send submitted text to the configured DeepSeek API and save successful results in the database. History is tied to an anonymous browser ID, not a login account.
                          - - On a remote deployment, voice recordings are sent to that server for transcription and temporary audio files are removed after processing.
                            - - Do not expose this service publicly without reviewing privacy, retention, rate limiting and abuse controls.
                             
                              - ## Main files
                             
                              - - `app.py` — Flask API, news collection, analysis, history and transcription.
                                - - `index.html` — UI and interactions.
                                  - - `assets/` — local styles, fonts, scripts, images and tour audio.
                                    - - `render.yaml`, `Dockerfile` — Render blueprint and container runtime.
                                      - - `docker-compose.yml`, `deploy/` — optional self-hosted PostgreSQL/Nginx templates.
                                        - 
