# Historical Discussion Platform

A Ruby on Rails application for discussing historical topics with a sophisticated ranking system, real-time interactions, and modern web technologies.

## Features

- **User Authentication**: Secure session-based authentication with password reset
- **Post Management**: Create, view, and manage historical discussion posts
- **Voting System**: Upvote posts with one-vote-per-user limitation
- **Comments**: Real-time commenting system with Turbo Streams
- **Smart Ranking**: Time-decay algorithm for post ranking (similar to Hacker News)
- **Regional Filtering**: Filter posts by historical regions
- **Modern UI**: Responsive design with Tailwind CSS and Hotwire
- **Real-time Updates**: Dynamic interactions with Stimulus controllers

## Technology Stack

- **Backend**: Ruby on Rails 7.x
- **Database**: PostgreSQL
- **Frontend**: Hotwire (Turbo + Stimulus)
- **Styling**: Tailwind CSS
- **Authentication**: Custom session-based system
- **Email**: Action Mailer with background jobs

## Quick Start

### Prerequisites

- Ruby 3.x
- PostgreSQL
- Node.js (for asset compilation)
- Bundler

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd historical-discussion-platform
   ```

2. **Install dependencies**
   ```bash
   bundle install
   npm install
   ```

3. **Setup database**
   ```bash
   rails db:create
   rails db:migrate
   rails db:seed
   ```

4. **Start the development server**
   ```bash
   bin/dev
   ```

5. **Visit the application**
   Open [http://localhost:3000](http://localhost:3000) in your browser

## Application Structure

### Models

- **User**: User accounts with email/password authentication
- **Post**: Historical discussion posts with ranking algorithm
- **Comment**: Comments on posts with real-time updates
- **Vote**: Upvotes on posts (one per user per post)
- **Session**: User session management

### Controllers

- **PostsController**: Post CRUD operations and ranking
- **CommentsController**: Comment creation with Turbo Streams
- **VotesController**: Voting functionality with real-time updates
- **SessionsController**: User authentication
- **PasswordsController**: Password reset functionality

### Key Features

#### Smart Post Ranking

Posts are ranked using a time-decay algorithm that balances popularity with recency:

```ruby
# Ranking formula: votes * exp(-hours_age / 24.0)
post.ranking_score  # => 3.2
```

#### Real-time Interactions

- **Comments**: Added instantly with Turbo Streams
- **Votes**: Vote counts update without page refresh
- **Flash Messages**: Auto-dismissing notifications

#### Regional Organization

Posts can be tagged with historical regions:
- Mediterranean, Mesopotamia, Egypt, Persia
- Indian Subcontinent, East Asia, Northern Europe
- Sub-Saharan Africa, North America, South America, Alaska

## API Documentation

For detailed API documentation, see [API_DOCUMENTATION.md](./API_DOCUMENTATION.md).

### Quick API Examples

#### Create a Post
```bash
curl -X POST "http://localhost:3000/posts" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -H "Cookie: session_id=your_session_cookie" \
  -d "post[title]=Ancient Rome&post[content]=The Roman Empire's lasting legacy&post[region]=Mediterranean"
```

#### Add a Comment
```bash
curl -X POST "http://localhost:3000/posts/1/comments" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -H "Cookie: session_id=your_session_cookie" \
  -d "comment[content]=Excellent analysis!"
```

#### Vote on a Post
```bash
curl -X POST "http://localhost:3000/posts/1/votes" \
  -H "Cookie: session_id=your_session_cookie"
```

## Development

### Running Tests

```bash
# Run all tests
rails test

# Run specific test files
rails test test/models/user_test.rb
rails test test/controllers/posts_controller_test.rb
```

### Code Quality

```bash
# Run RuboCop
bundle exec rubocop

# Run Brakeman security scanner
bundle exec brakeman

# Run all checks
bin/check
```

### Database Operations

```bash
# Create and migrate database
rails db:create db:migrate

# Reset database with seed data
rails db:reset

# Run specific migration
rails db:migrate VERSION=20231201000000
```

## Configuration

### Environment Variables

Create a `.env` file in the root directory:

```bash
# Database
DATABASE_URL=postgresql://username:password@localhost/historical_discussion_development

# Email (for production)
SMTP_HOST=smtp.example.com
SMTP_PORT=587
SMTP_USERNAME=your_email@example.com
SMTP_PASSWORD=your_password

# Security
SECRET_KEY_BASE=your_secret_key_base
```

### Email Configuration

The application uses Action Mailer for password reset emails. Configure SMTP settings in `config/environments/production.rb`:

```ruby
config.action_mailer.smtp_settings = {
  address: ENV['SMTP_HOST'],
  port: ENV['SMTP_PORT'],
  user_name: ENV['SMTP_USERNAME'],
  password: ENV['SMTP_PASSWORD'],
  authentication: 'plain',
  enable_starttls_auto: true
}
```

## Deployment

### Using Kamal

The application includes Kamal configuration for easy deployment:

```bash
# Deploy to production
kamal deploy

# Check deployment status
kamal app logs

# Access production console
kamal app exec -i --interactive
```

### Manual Deployment

1. **Prepare the server**
   ```bash
   # Install dependencies
   sudo apt update
   sudo apt install postgresql postgresql-contrib nginx
   
   # Install Ruby and Node.js
   # (Use rbenv/nvm or system packages)
   ```

2. **Deploy the application**
   ```bash
   # Clone repository
   git clone <repository-url>
   cd historical-discussion-platform
   
   # Install dependencies
   bundle install --deployment
   npm install --production
   
   # Setup database
   rails db:create db:migrate db:seed
   
   # Precompile assets
   rails assets:precompile
   
   # Start the application
   rails server -e production
   ```

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Development Guidelines

- Follow Ruby and Rails style guides
- Write tests for new features
- Update documentation for API changes
- Use meaningful commit messages
- Ensure all tests pass before submitting PR

## Security

The application implements several security measures:

- **Password Security**: Uses Rails' `has_secure_password` with bcrypt
- **Session Security**: Signed, HTTP-only cookies with SameSite protection
- **Rate Limiting**: Login attempts limited to 10 per 3 minutes
- **CSRF Protection**: Built-in Rails CSRF protection
- **SQL Injection Prevention**: Uses parameterized queries
- **XSS Protection**: Escapes user input in views

## Performance

### Database Optimization

- **Eager Loading**: Uses `includes` to prevent N+1 queries
- **Indexing**: Proper database indexes on foreign keys and search fields
- **Ranking Algorithm**: Optimized for large datasets

### Caching

- **Fragment Caching**: Cached partials for repeated content
- **Query Caching**: Rails automatic query caching
- **Asset Caching**: Precompiled assets with fingerprinting

## Monitoring

### Health Checks

The application includes health check endpoints:

- **Basic Health**: `GET /up` - Returns 200 if application is running
- **Database Health**: Checks database connectivity

### Logging

- **Request Logging**: All HTTP requests logged
- **Error Logging**: Exceptions logged with stack traces
- **Performance Logging**: Slow query detection

## Troubleshooting

### Common Issues

1. **Database Connection Error**
   ```bash
   # Check PostgreSQL is running
   sudo systemctl status postgresql
   
   # Check database configuration
   rails db:version
   ```

2. **Asset Compilation Error**
   ```bash
   # Clear asset cache
   rails assets:clobber
   rails assets:precompile
   ```

3. **Session Issues**
   ```bash
   # Clear session store
   rails tmp:clear
   ```

### Getting Help

- Check the [API Documentation](./API_DOCUMENTATION.md)
- Review the Rails logs in `log/` directory
- Search existing issues in the repository
- Create a new issue with detailed information

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Built with [Ruby on Rails](https://rubyonrails.org/)
- Styled with [Tailwind CSS](https://tailwindcss.com/)
- Enhanced with [Hotwire](https://hotwired.dev/)
- Inspired by Hacker News ranking algorithm

---

For detailed API documentation, see [API_DOCUMENTATION.md](./API_DOCUMENTATION.md).