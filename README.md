# Project Manager

A simple project management system built with Ruby on Rails.  
Users can create projects, manage tasks, and track task statuses using a Kanban-style board.

---

## Features

- User authentication (Devise)
- Create, edit, delete, and view projects
- Create, edit, delete, and view tasks inside projects
- Task statuses:
  - To Do
  - In Progress
  - In Testing
  - Rejected
  - Done
- Status transitions with validation rules
- Kanban-style task board (tasks grouped by status)
- Hint system showing available transitions for each task
- Full test coverage (RSpec + FactoryBot)

---

## Technologies

- Ruby 3.2.3
- Rails 8.1.3
- SQLite (development)
- Devise (authentication)
- RSpec (testing)
- FactoryBot + Faker (test data)
- RuboCop (code linting)
- Sorbet (static type checking, partial)

---

##  Running the app

- "rails server" or "rails s"

## Running tests

- bundle exec rspec

---

##  Installation

```bash
git clone https://github.com/SviridenkoV/Project_manager
bundle install
cd project_manager
bundle install
rails db:create
rails db:migrate

```
---

##  Created by SviridenkoV



