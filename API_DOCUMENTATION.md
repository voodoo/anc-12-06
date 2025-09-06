# API Documentation

This document provides comprehensive documentation for all public APIs, functions, and components in the Rails application.

## Table of Contents

1. [Controllers & Routes](#controllers--routes)
2. [Models & Associations](#models--associations)
3. [Stimulus Controllers](#stimulus-controllers)
4. [Helper Methods](#helper-methods)
5. [Authentication System](#authentication-system)
6. [Mailers](#mailers)
7. [Usage Examples](#usage-examples)

---

## Controllers & Routes

### PostsController

**Base Path:** `/posts`

The PostsController handles all post-related operations including creation, viewing, and management.

#### Actions

##### `GET /posts` (index)
- **Description:** Lists all posts ranked by popularity and time decay
- **Authentication:** Required
- **Parameters:**
  - `region` (optional): Filter posts by region
- **Response:** HTML page with ranked posts
- **Example:**
  ```ruby
  # URL: /posts?region=Mediterranean
  # Returns posts filtered by Mediterranean region
  ```

##### `GET /posts/:id` (show)
- **Description:** Displays a specific post with its comments and vote count
- **Authentication:** Required
- **Parameters:**
  - `id` (required): Post ID
- **Response:** HTML page showing the post details

##### `GET /posts/new` (new)
- **Description:** Shows form to create a new post
- **Authentication:** Required
- **Response:** HTML form for creating a new post

##### `POST /posts` (create)
- **Description:** Creates a new post
- **Authentication:** Required
- **Parameters:**
  - `post[title]` (required): Post title (3-255 characters)
  - `post[content]` (required): Post content (minimum 10 characters)
  - `post[region]` (optional): Geographic region
- **Response:** Redirects to created post or shows validation errors
- **Example:**
  ```ruby
  # POST /posts
  # Content-Type: application/x-www-form-urlencoded
  # 
  # post[title]=Ancient Rome
  # post[content]=A fascinating look at Roman civilization
  # post[region]=Mediterranean
  ```

### CommentsController

**Base Path:** `/posts/:post_id/comments`

The CommentsController handles comment creation for posts.

#### Actions

##### `POST /posts/:post_id/comments` (create)
- **Description:** Creates a new comment on a post
- **Authentication:** Required
- **Parameters:**
  - `post_id` (required): ID of the post to comment on
  - `comment[content]` (required): Comment content (2-1000 characters)
- **Response:** 
  - **Turbo Stream:** Updates the comments section dynamically
  - **HTML:** Redirects to the post page
- **Example:**
  ```ruby
  # POST /posts/1/comments
  # Content-Type: application/x-www-form-urlencoded
  # 
  # comment[content]=Great post! Very informative.
  ```

### VotesController

**Base Path:** `/posts/:post_id/votes`

The VotesController handles upvoting and removing votes from posts.

#### Actions

##### `POST /posts/:post_id/votes` (create)
- **Description:** Upvotes a post
- **Authentication:** Required
- **Parameters:**
  - `post_id` (required): ID of the post to upvote
- **Response:** 
  - **Turbo Stream:** Updates the vote buttons dynamically
  - **HTML:** Redirects to the post page
- **Validation:** Users can only upvote a post once

##### `DELETE /posts/:post_id/votes` (destroy)
- **Description:** Removes an upvote from a post
- **Authentication:** Required
- **Parameters:**
  - `post_id` (required): ID of the post to remove vote from
- **Response:** 
  - **Turbo Stream:** Updates the vote buttons dynamically
  - **HTML:** Redirects to the post page

### SessionsController

**Base Path:** `/session`

The SessionsController handles user authentication.

#### Actions

##### `GET /session/new` (new)
- **Description:** Shows login form
- **Authentication:** Not required
- **Response:** HTML login form

##### `POST /session` (create)
- **Description:** Authenticates user and creates session
- **Authentication:** Not required
- **Rate Limiting:** 10 attempts per 3 minutes
- **Parameters:**
  - `email_address` (required): User's email address
  - `password` (required): User's password
- **Response:** Redirects to intended page or shows error
- **Example:**
  ```ruby
  # POST /session
  # Content-Type: application/x-www-form-urlencoded
  # 
  # email_address=user@example.com
  # password=secretpassword
  ```

##### `DELETE /session` (destroy)
- **Description:** Logs out user and destroys session
- **Authentication:** Required
- **Response:** Redirects to login page

### PasswordsController

**Base Path:** `/passwords`

The PasswordsController handles password reset functionality.

#### Actions

##### `GET /passwords/new` (new)
- **Description:** Shows password reset request form
- **Authentication:** Not required
- **Response:** HTML form for requesting password reset

##### `POST /passwords` (create)
- **Description:** Sends password reset email
- **Authentication:** Not required
- **Parameters:**
  - `email_address` (required): User's email address
- **Response:** Redirects with success message (always shows success for security)

##### `GET /passwords/:token/edit` (edit)
- **Description:** Shows password reset form
- **Authentication:** Not required (token-based)
- **Parameters:**
  - `token` (required): Password reset token
- **Response:** HTML form for setting new password

##### `PATCH/PUT /passwords/:token` (update)
- **Description:** Updates user password
- **Authentication:** Not required (token-based)
- **Parameters:**
  - `token` (required): Password reset token
  - `password` (required): New password
  - `password_confirmation` (required): Password confirmation
- **Response:** Redirects to login page or shows error

---

## Models & Associations

### User Model

**File:** `app/models/user.rb`

The User model represents authenticated users in the system.

#### Attributes
- `email_address` (string): User's email (normalized to lowercase)
- `password_digest` (string): Encrypted password (managed by has_secure_password)

#### Associations
- `has_many :sessions` - User's active sessions
- `has_many :posts` - Posts created by user
- `has_many :votes` - Votes cast by user
- `has_many :upvoted_posts` - Posts upvoted by user (through votes)

#### Methods
- `authenticate_by(email_address:, password:)` - Class method for authentication
- `find_by_password_reset_token!(token)` - Class method for password reset

#### Validations
- Email address is normalized (stripped and downcased)
- Password is secured using Rails' `has_secure_password`

#### Example Usage
```ruby
# Create a new user
user = User.create!(
  email_address: "user@example.com",
  password: "secretpassword",
  password_confirmation: "secretpassword"
)

# Authenticate user
user = User.authenticate_by(
  email_address: "user@example.com",
  password: "secretpassword"
)

# Get user's posts
user.posts

# Get posts user has upvoted
user.upvoted_posts
```

### Post Model

**File:** `app/models/post.rb`

The Post model represents content posts in the system.

#### Attributes
- `title` (string): Post title
- `content` (text): Post content
- `region` (string): Geographic region (optional)
- `user_id` (integer): ID of the user who created the post
- `created_at` (datetime): Creation timestamp
- `updated_at` (datetime): Last update timestamp

#### Associations
- `belongs_to :user` - Post author
- `has_many :votes` - Votes on the post
- `has_many :voters` - Users who voted on the post
- `has_many :comments` - Comments on the post

#### Validations
- `title`: Required, 3-255 characters
- `content`: Required, minimum 10 characters

#### Methods

##### `upvote_count`
- **Description:** Returns the total number of votes on the post
- **Returns:** Integer
- **Example:**
  ```ruby
  post.upvote_count # => 5
  ```

##### `ranking_score`
- **Description:** Calculates the post's ranking score using time decay algorithm
- **Returns:** Float
- **Algorithm:** `votes_count * exp(-hours_age / 24.0)`
- **Example:**
  ```ruby
  post.ranking_score # => 3.2
  ```

#### Scopes

##### `ranked`
- **Description:** Returns posts ordered by ranking score (highest first)
- **Returns:** ActiveRecord::Relation
- **Example:**
  ```ruby
  Post.ranked.limit(10) # Top 10 posts by ranking
  ```

#### Example Usage
```ruby
# Create a new post
post = user.posts.create!(
  title: "Ancient Rome",
  content: "A fascinating look at Roman civilization and its impact on the world.",
  region: "Mediterranean"
)

# Get ranking information
post.upvote_count    # => 15
post.ranking_score   # => 12.3

# Get ranked posts
Post.ranked.includes(:user, :votes)

# Filter by region
Post.ranked.where(region: "Mediterranean")
```

### Comment Model

**File:** `app/models/comment.rb`

The Comment model represents comments on posts.

#### Attributes
- `content` (text): Comment content
- `user_id` (integer): ID of the user who created the comment
- `post_id` (integer): ID of the post being commented on
- `created_at` (datetime): Creation timestamp
- `updated_at` (datetime): Last update timestamp

#### Associations
- `belongs_to :user` - Comment author
- `belongs_to :post` - Post being commented on

#### Validations
- `content`: Required, 2-1000 characters

#### Scopes
- `default_scope { order(created_at: :desc) }` - Comments ordered by newest first

#### Example Usage
```ruby
# Create a comment
comment = post.comments.create!(
  content: "Great post! Very informative.",
  user: current_user
)

# Get comments for a post (newest first)
post.comments

# Get user's comments
user.comments
```

### Vote Model

**File:** `app/models/vote.rb`

The Vote model represents upvotes on posts.

#### Attributes
- `user_id` (integer): ID of the user who voted
- `post_id` (integer): ID of the post being voted on
- `created_at` (datetime): Creation timestamp
- `updated_at` (datetime): Last update timestamp

#### Associations
- `belongs_to :user` - User who voted
- `belongs_to :post` - Post being voted on

#### Validations
- `user_id`: Must be unique per post (users can only vote once per post)

#### Example Usage
```ruby
# Create a vote
vote = user.votes.create!(post: post)

# Check if user has voted on a post
user.votes.exists?(post: post)

# Get all votes for a post
post.votes

# Get all posts voted on by a user
user.upvoted_posts
```

### Session Model

**File:** `app/models/session.rb`

The Session model represents user sessions.

#### Attributes
- `user_id` (integer): ID of the user
- `user_agent` (string): Browser user agent
- `ip_address` (string): User's IP address
- `created_at` (datetime): Creation timestamp
- `updated_at` (datetime): Last update timestamp

#### Associations
- `belongs_to :user` - Session owner

### Current Model

**File:** `app/models/current.rb`

The Current model provides thread-safe access to the current session and user.

#### Attributes
- `session` - Current session object
- `user` - Current user (delegated from session)

#### Example Usage
```ruby
# Access current user
Current.user

# Access current session
Current.session

# Set current session
Current.session = session
```

---

## Stimulus Controllers

### CommentFormController

**File:** `app/javascript/controllers/comment_form_controller.js`

Handles comment form interactions and validation.

#### Targets
- `form` - The comment form element
- `input` - The comment input field
- `submit` - The submit button

#### Methods

##### `connect()`
- **Description:** Initializes the controller and validates input
- **Called:** Automatically when controller connects

##### `submitOnEnter(event)`
- **Description:** Handles Enter key submission (Shift+Enter for new lines)
- **Parameters:**
  - `event` - Keyboard event
- **Usage:** Add `data-action="keydown->comment-form#submitOnEnter"` to input

##### `validateInput()`
- **Description:** Enables/disables submit button based on input content
- **Called:** Automatically on connect and input changes

##### `submit(event)`
- **Description:** Submits the form if content is valid
- **Parameters:**
  - `event` - Form event
- **Usage:** Add `data-action="click->comment-form#submit"` to submit button

##### `reset()`
- **Description:** Clears the form and resets validation
- **Usage:** Call after successful comment submission

#### Example Usage
```html
<div data-controller="comment-form">
  <%= form_with model: [@post, Comment.new], 
      data: { comment_form_target: "form" } do |form| %>
    <%= form.text_area :content, 
        data: { 
          comment_form_target: "input",
          action: "input->comment-form#validateInput keydown->comment-form#submitOnEnter"
        } %>
    <%= form.submit "Post Comment", 
        data: { 
          comment_form_target: "submit",
          action: "click->comment-form#submit"
        } %>
  <% end %>
</div>
```

### AutoDismissController

**File:** `app/javascript/controllers/auto_dismiss_controller.js`

Automatically dismisses flash messages after a specified timeout.

#### Targets
- `message` - Flash message elements to dismiss

#### Values
- `timeout` - Timeout in milliseconds (default: 0, no auto-dismiss)

#### Methods

##### `connect()`
- **Description:** Sets up auto-dismiss timer if timeout is specified
- **Called:** Automatically when controller connects

##### `dismiss()`
- **Description:** Animates and removes all message targets
- **Animation:** Fade out with upward slide

#### Example Usage
```html
<div data-controller="auto-dismiss" 
     data-auto-dismiss-timeout-value="5000">
  <div data-auto-dismiss-target="message" 
       class="flash-message">
    Success message here
  </div>
</div>
```

### ResetFormController

**File:** `app/javascript/controllers/reset_form_controller.js`

Provides form reset functionality.

#### Methods

##### `reset()`
- **Description:** Resets the form to its initial state
- **Usage:** Call after successful form submission

#### Example Usage
```html
<div data-controller="reset-form">
  <form data-reset-form-target="form">
    <!-- form fields -->
  </form>
  <button data-action="click->reset-form#reset">
    Reset Form
  </button>
</div>
```

---

## Helper Methods

### PostsHelper

**File:** `app/helpers/posts_helper.rb`

Provides styling utilities for posts.

#### Methods

##### `region_color_classes(region)`
- **Description:** Returns Tailwind CSS classes for region-specific styling
- **Parameters:**
  - `region` (string): Geographic region name
- **Returns:** String of CSS classes
- **Supported Regions:**
  - Mediterranean, Mesopotamia, Egypt, Persia
  - Indian Subcontinent, East Asia, Northern Europe
  - Sub-Saharan Africa, North America, South America, Alaska
- **Example:**
  ```ruby
  region_color_classes("Mediterranean")
  # => "bg-blue-50 text-blue-700 ring-blue-700/10"
  ```

#### Example Usage
```erb
<div class="<%= region_color_classes(post.region) %>">
  <%= post.region %>
</div>
```

### FlashHelper

**File:** `app/helpers/flash_helper.rb`

Provides styling and icons for flash messages.

#### Methods

##### `flash_class(type)`
- **Description:** Returns CSS classes for flash message styling
- **Parameters:**
  - `type` (symbol): Flash message type (:notice, :success, :error, :alert, :warning)
- **Returns:** String of CSS classes
- **Example:**
  ```ruby
  flash_class(:notice)  # => "bg-green-50 text-green-800"
  flash_class(:error)   # => "bg-red-50 text-red-800"
  ```

##### `flash_icon(type)`
- **Description:** Returns SVG icon for flash message type
- **Parameters:**
  - `type` (symbol): Flash message type
- **Returns:** HTML string with SVG icon
- **Icons:**
  - :notice, :success: Checkmark circle
  - :error, :alert: X circle
  - :warning: Warning triangle
  - Default: Plus circle

#### Example Usage
```erb
<div class="<%= flash_class(flash.keys.first) %>">
  <%= flash_icon(flash.keys.first) %>
  <%= flash[flash.keys.first] %>
</div>
```

---

## Authentication System

### Authentication Concern

**File:** `app/controllers/concerns/authentication.rb`

Provides authentication functionality for controllers.

#### Class Methods

##### `allow_unauthenticated_access(**options)`
- **Description:** Allows access to specified actions without authentication
- **Parameters:**
  - `only:` - Array of action names to allow
  - `except:` - Array of action names to require authentication
- **Example:**
  ```ruby
  class SessionsController < ApplicationController
    allow_unauthenticated_access only: [:new, :create]
  end
  ```

#### Instance Methods

##### `authenticated?`
- **Description:** Checks if user is currently authenticated
- **Returns:** Boolean
- **Helper Method:** Available in views

##### `require_authentication`
- **Description:** Redirects to login if user is not authenticated
- **Returns:** Boolean (false if redirected)
- **Before Action:** Automatically called unless skipped

##### `resume_session`
- **Description:** Resumes session from cookie
- **Returns:** Session object or nil

##### `start_new_session_for(user)`
- **Description:** Creates new session for user
- **Parameters:**
  - `user` - User object
- **Returns:** Session object
- **Side Effects:** Sets cookie and Current.session

##### `terminate_session`
- **Description:** Destroys current session
- **Side Effects:** Removes cookie and clears Current.session

##### `after_authentication_url`
- **Description:** Returns URL to redirect to after authentication
- **Returns:** String URL

#### Example Usage
```ruby
class PostsController < ApplicationController
  # All actions require authentication by default
  
  def index
    # Current.user is available here
    @posts = Post.ranked.includes(:user)
  end
end

class SessionsController < ApplicationController
  allow_unauthenticated_access only: [:new, :create]
  
  def create
    if user = User.authenticate_by(params.permit(:email_address, :password))
      start_new_session_for user
      redirect_to after_authentication_url
    else
      redirect_to new_session_path, alert: "Invalid credentials"
    end
  end
end
```

---

## Mailers

### PasswordsMailer

**File:** `app/mailers/passwords_mailer.rb`

Handles password reset emails.

#### Methods

##### `reset(user)`
- **Description:** Sends password reset email to user
- **Parameters:**
  - `user` - User object
- **Subject:** "Reset your password"
- **To:** User's email address
- **Example:**
  ```ruby
  PasswordsMailer.reset(user).deliver_later
  ```

### ApplicationMailer

**File:** `app/mailers/application_mailer.rb`

Base mailer class with default configuration.

#### Configuration
- **From:** "from@example.com"
- **Layout:** "mailer"

---

## Usage Examples

### Creating a Post with Comments and Votes

```ruby
# 1. Create a user
user = User.create!(
  email_address: "historian@example.com",
  password: "secretpassword",
  password_confirmation: "secretpassword"
)

# 2. Create a post
post = user.posts.create!(
  title: "The Fall of Rome",
  content: "An analysis of the factors that led to the decline of the Roman Empire.",
  region: "Mediterranean"
)

# 3. Add comments
comment1 = post.comments.create!(
  content: "Fascinating analysis!",
  user: user
)

# 4. Vote on the post
vote = user.votes.create!(post: post)

# 5. Check ranking
post.upvote_count    # => 1
post.ranking_score   # => 1.0 (if posted recently)
```

### Using Stimulus Controllers

```erb
<!-- Comment form with validation -->
<div data-controller="comment-form">
  <%= form_with model: [@post, Comment.new], 
      data: { comment_form_target: "form" } do |form| %>
    <%= form.text_area :content, 
        placeholder: "Add a comment...",
        data: { 
          comment_form_target: "input",
          action: "input->comment-form#validateInput keydown->comment-form#submitOnEnter"
        } %>
    <%= form.submit "Post Comment", 
        disabled: true,
        data: { 
          comment_form_target: "submit",
          action: "click->comment-form#submit"
        } %>
  <% end %>
</div>

<!-- Auto-dismissing flash message -->
<div data-controller="auto-dismiss" 
     data-auto-dismiss-timeout-value="3000">
  <div data-auto-dismiss-target="message" 
       class="bg-green-50 text-green-800 p-4 rounded">
    Comment posted successfully!
  </div>
</div>
```

### API Endpoints

```bash
# Get all posts
curl -X GET "http://localhost:3000/posts" \
  -H "Cookie: session_id=your_session_cookie"

# Create a new post
curl -X POST "http://localhost:3000/posts" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -H "Cookie: session_id=your_session_cookie" \
  -d "post[title]=Ancient Greece&post[content]=The cradle of Western civilization&post[region]=Mediterranean"

# Vote on a post
curl -X POST "http://localhost:3000/posts/1/votes" \
  -H "Cookie: session_id=your_session_cookie"

# Add a comment
curl -X POST "http://localhost:3000/posts/1/comments" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -H "Cookie: session_id=your_session_cookie" \
  -d "comment[content]=Great post!"
```

---

## Error Handling

### Validation Errors

All models include comprehensive validation with user-friendly error messages:

- **Post validation:** Title (3-255 chars), Content (min 10 chars)
- **Comment validation:** Content (2-1000 chars)
- **Vote validation:** One vote per user per post
- **User validation:** Email normalization, secure password

### Authentication Errors

- **Rate limiting:** 10 login attempts per 3 minutes
- **Session management:** Automatic session cleanup
- **Redirect handling:** Users redirected to intended page after login

### Flash Messages

The application uses a comprehensive flash message system with:
- **Success messages:** Green styling with checkmark icon
- **Error messages:** Red styling with X icon
- **Warning messages:** Yellow styling with warning icon
- **Auto-dismiss:** Configurable timeout for automatic dismissal

---

This documentation covers all public APIs, functions, and components in the Rails application. For additional information or examples, refer to the source code or contact the development team.