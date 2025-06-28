# The Art Exchange - Developer Wiki

## Overview

**The Art Exchange** is a modern, community-driven marketplace and collection management platform for art poster enthusiasts. Built with Rails 8, it serves as a comprehensive platform where users can discover artwork, track collections, and connect with other collectors.

### 🎯 Mission
To create the definitive platform for poster collectors to manage their collections, discover new artwork, and connect with a passionate community of art enthusiasts.

### 🏗️ Current Status
- **Phase 1** (Foundation): Nearly complete - Authentication, core models, AI integration
- **Phase 2** (Social Features): In progress - Collections, discovery, enhanced search  
- **Phase 3** (Marketplace): Planned - Sales, transactions, AI valuations

## Quick Navigation

### 🚀 Getting Started
- **[Getting Started](Getting-Started)** - Developer onboarding and local setup
- **[Development Workflow](Development-Workflow)** - Contributing guidelines and processes

### 🏗️ Technical Documentation  
- **[Application Architecture](Application-Architecture)** - Technical deep dive and system design
- **[Database Schema](Database-Schema)** - Model relationships and data structure
- **[Authentication System](Authentication-System)** - OTP, OAuth, and security features
- **[AI Integration](AI-Integration)** - Claude API and visual metadata system

### 📋 Development Guides
- **[Testing Guide](Testing-Guide)** - RSpec, security scanning, and quality assurance
- **[Coding Standards](Coding-Standards-&-Style-Guide)** - Style guide and best practices
- **[Security Guidelines](Security-Guidelines)** - Security requirements and scanning

### 🚀 Operations & Deployment
- **[Deployment Guide](Deployment-Guide)** - Heroku deployment and environment setup
- **[Migration Documentation](Migration-Documentation)** - Legacy system migration approach

### 📖 Reference Documentation
- **[Future API Documentation](Future-API-Documentation)** - Planned API endpoints and structure
- **[Issue & PR Templates](Issue-&-PR-Templates)** - Development process documentation
- **[Troubleshooting](Troubleshooting)** - Common issues and solutions

## Key Technologies

- **Framework**: Rails 8 with Hotwire (Turbo + Stimulus)
- **Database**: PostgreSQL with full-text search
- **Frontend**: Tailwind CSS for styling
- **Authentication**: OTP (passwordless) + OAuth + traditional passwords
- **AI**: Anthropic Claude API for visual metadata analysis
- **Deployment**: Heroku with Kamal deployment system
- **Storage**: AWS S3 with Active Storage

## Repository Links

- **Main Documentation**: [README.md](../blob/main/README.md)
- **Architecture Details**: [ARCHITECTURE.md](../blob/main/ARCHITECTURE.md) 
- **Development Rules**: [CLAUDE.md](../blob/main/CLAUDE.md)
- **Deployment Guide**: [DEPLOYMENT.md](../blob/main/DEPLOYMENT.md)
- **Authentication Details**: [AUTHENTICATION.md](../blob/main/AUTHENTICATION.md)

## Development Phases

### Phase 1: Foundation ✅
- Rails 8 application setup
- User authentication (OTP + OAuth)
- Core models (Users, Posters, Artists, Venues)
- AI-powered visual metadata analysis
- Basic search and filtering

### Phase 2: Social Features 🔄
- User collections and showcases
- Enhanced discovery and search
- Social features and sharing
- Admin interface

### Phase 3: Marketplace 📋
- Item listings and sales
- Transaction management
- AI-powered valuations
- Advanced analytics

## Contributing

This project follows a structured development workflow. Please see the [Development Workflow](Development-Workflow) page for detailed guidelines on:

- Creating GitHub issues
- Branch management and pull requests
- Testing requirements
- Code review process

## Community

- **Issues**: [GitHub Issues](../issues) for bug reports and feature requests
- **Discussions**: [GitHub Discussions](../discussions) for community conversations
- **Pull Requests**: [GitHub PRs](../pulls) for code contributions

---

*Last updated: June 2025*