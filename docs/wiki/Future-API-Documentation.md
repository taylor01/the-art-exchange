# Future API Documentation

## Overview

The Art Exchange is designed with a comprehensive API strategy that will evolve through the development phases. Currently, the application focuses on web interface functionality, but a full RESTful API is planned for Phase 2 and 3 features to support mobile applications, third-party integrations, and advanced functionality.

## Current API State

### Existing Internal APIs
The application currently uses JSON responses for internal AJAX interactions:

```ruby
# Current internal API endpoints
GET  /posters.json           # Poster search results
POST /user_posters           # Collection management
GET  /admin/posters.json     # Admin interface data
```

### Authentication Framework
Authentication infrastructure is ready for API expansion:
- **OTP-based authentication** for passwordless access
- **OAuth integration** for third-party applications
- **Session management** extensible to API tokens
- **Rate limiting** already implemented

## Planned API Architecture

### API Versioning Strategy
```
/api/v1/    # Initial public API (Phase 2)
/api/v2/    # Enhanced features (Phase 3)
/api/v3/    # Future marketplace features
```

### Authentication Methods

#### 1. API Token Authentication (Planned)
```ruby
# User API token generation
class User < ApplicationRecord
  has_secure_token :api_token
  
  def regenerate_api_token!
    update!(api_token: SecureRandom.hex(32))
  end
end

# Usage in requests
curl -H "Authorization: Bearer user_api_token" \
     https://api.theartexch.com/api/v1/collections
```

#### 2. OAuth 2.0 (Phase 3)
```ruby
# OAuth scope-based access
scopes = [
  'read:posters',      # Read poster data
  'read:collections',  # Read user collections
  'write:collections', # Modify user collections
  'read:profile',      # Read user profile
  'write:profile'      # Modify user profile
]
```

## Phase 2 API Features

### Public Poster API

#### Poster Listing and Search
```ruby
# GET /api/v1/posters
{
  "data": [
    {
      "id": 1076,
      "type": "poster",
      "attributes": {
        "title": "Midnight Moon",
        "year": 2019,
        "description": "Beautiful celestial artwork...",
        "print_run_size": 500,
        "slug": "midnight-moon-red-rocks-2019",
        "created_at": "2019-06-15T12:00:00Z",
        "updated_at": "2024-06-15T12:00:00Z"
      },
      "relationships": {
        "artists": {
          "data": [
            {"id": 1, "type": "artist"}
          ]
        },
        "venue": {
          "data": {"id": 5, "type": "venue"}
        },
        "band": {
          "data": {"id": 10, "type": "band"}
        }
      },
      "links": {
        "self": "/api/v1/posters/1076",
        "images": "/api/v1/posters/1076/images"
      }
    }
  ],
  "included": [
    {
      "id": 1,
      "type": "artist",
      "attributes": {
        "name": "Sarah Chen",
        "bio": "Contemporary poster artist...",
        "website": "https://sarahchen.art"
      }
    }
  ],
  "meta": {
    "total_count": 773,
    "current_page": 1,
    "per_page": 25,
    "total_pages": 31
  },
  "links": {
    "self": "/api/v1/posters?page=1",
    "next": "/api/v1/posters?page=2",
    "last": "/api/v1/posters?page=31"
  }
}
```

#### Advanced Search Parameters
```ruby
# GET /api/v1/posters?search=red+rocks&year=2019&artist=sarah+chen
{
  "filters": {
    "search": "red rocks",
    "year": [2018, 2019, 2020],
    "artist": ["sarah-chen", "mike-dubois"],
    "venue": ["red-rocks-amphitheatre"],
    "band": ["dave-matthews-band"],
    "has_images": true,
    "print_run_size": {"min": 100, "max": 1000}
  },
  "sort": {
    "by": ["year", "title", "created_at"],
    "order": "desc"
  }
}
```

#### Individual Poster Details
```ruby
# GET /api/v1/posters/1076
{
  "data": {
    "id": 1076,
    "type": "poster",
    "attributes": {
      "title": "Midnight Moon",
      "description": "...",
      "visual_metadata": {
        "visual": {
          "color_palette": ["black", "white", "blue"],
          "art_style": "minimalist",
          "composition": "centered_focal_point"
        },
        "thematic": {
          "primary_themes": ["celestial", "night_sky"],
          "mood": ["peaceful", "dreamy"]
        }
      }
    },
    "relationships": {
      "images": {
        "data": [
          {"id": "abc123", "type": "image"}
        ]
      }
    }
  },
  "included": [
    {
      "id": "abc123",
      "type": "image",
      "attributes": {
        "url": "https://s3.amazonaws.com/bucket/signed-url",
        "variants": {
          "thumbnail": "https://s3.amazonaws.com/bucket/thumb-signed-url",
          "medium": "https://s3.amazonaws.com/bucket/medium-signed-url",
          "large": "https://s3.amazonaws.com/bucket/large-signed-url"
        }
      }
    }
  ]
}
```

### User Collection API

#### Collection Overview
```ruby
# GET /api/v1/collections (authenticated)
{
  "data": {
    "id": "user-123-collection",
    "type": "collection",
    "attributes": {
      "total_posters": 45,
      "owned_count": 23,
      "wanted_count": 15,
      "watching_count": 7,
      "estimated_value": 2850.00,
      "last_updated": "2024-06-15T10:30:00Z"
    },
    "relationships": {
      "owned_posters": {
        "links": {
          "related": "/api/v1/collections/owned"
        }
      },
      "wanted_posters": {
        "links": {
          "related": "/api/v1/collections/wanted"
        }
      }
    }
  }
}
```

#### Collection Items
```ruby
# GET /api/v1/collections/owned
{
  "data": [
    {
      "id": "user-poster-456",
      "type": "user_poster",
      "attributes": {
        "status": "owned",
        "condition": "mint",
        "price_paid": 125.00,
        "notes": "Purchased at venue",
        "acquired_date": "2019-06-15",
        "created_at": "2024-01-15T12:00:00Z"
      },
      "relationships": {
        "poster": {
          "data": {"id": 1076, "type": "poster"}
        }
      }
    }
  ],
  "included": [
    {
      "id": 1076,
      "type": "poster",
      "attributes": {
        "title": "Midnight Moon",
        "year": 2019
      }
    }
  ]
}
```

#### Collection Management
```ruby
# POST /api/v1/collections/items
{
  "data": {
    "type": "user_poster",
    "attributes": {
      "poster_id": 1076,
      "status": "owned",
      "condition": "excellent",
      "price_paid": 75.00,
      "notes": "Great condition, small corner bend"
    }
  }
}

# PATCH /api/v1/collections/items/456
{
  "data": {
    "id": "456",
    "type": "user_poster",
    "attributes": {
      "condition": "good",
      "notes": "Updated condition assessment"
    }
  }
}

# DELETE /api/v1/collections/items/456
# Removes item from collection
```

## Phase 3 API Features (Marketplace)

### Marketplace Listings API

#### Create Listing
```ruby
# POST /api/v1/marketplace/listings
{
  "data": {
    "type": "listing",
    "attributes": {
      "user_poster_id": 456,
      "asking_price": 150.00,
      "description": "Excellent condition, ready to ship",
      "shipping_included": true,
      "international_shipping": false,
      "payment_methods": ["paypal", "venmo"],
      "status": "active"
    }
  }
}
```

#### Browse Marketplace
```ruby
# GET /api/v1/marketplace/listings
{
  "data": [
    {
      "id": 789,
      "type": "listing",
      "attributes": {
        "asking_price": 150.00,
        "description": "...",
        "status": "active",
        "created_at": "2024-06-01T10:00:00Z",
        "view_count": 45,
        "favorite_count": 3
      },
      "relationships": {
        "poster": {"data": {"id": 1076, "type": "poster"}},
        "seller": {"data": {"id": 123, "type": "user"}}
      }
    }
  ]
}
```

### Transaction API

#### Transaction Creation
```ruby
# POST /api/v1/transactions
{
  "data": {
    "type": "transaction",
    "attributes": {
      "listing_id": 789,
      "payment_method": "paypal",
      "shipping_address": {
        "street": "123 Main St",
        "city": "Denver",
        "state": "CO",
        "zip": "80202",
        "country": "US"
      }
    }
  }
}
```

#### Transaction Status
```ruby
# GET /api/v1/transactions/456
{
  "data": {
    "id": 456,
    "type": "transaction",
    "attributes": {
      "status": "completed",
      "total_amount": 150.00,
      "shipping_cost": 15.00,
      "payment_status": "confirmed",
      "tracking_number": "1Z999AA1234567890",
      "completed_at": "2024-06-15T14:30:00Z"
    }
  }
}
```

## AI-Powered API Features

### Visual Metadata API

#### Poster Analysis
```ruby
# GET /api/v1/posters/1076/metadata
{
  "data": {
    "id": "metadata-1076",
    "type": "visual_metadata",
    "attributes": {
      "analysis_version": "1.2",
      "generated_at": "2024-06-15T09:00:00Z",
      "visual": {
        "color_palette": ["#000000", "#ffffff", "#4a90e2"],
        "dominant_colors": ["black", "white", "blue"],
        "art_style": "minimalist",
        "composition": "centered_focal_point",
        "complexity": "simple"
      },
      "thematic": {
        "primary_themes": ["celestial", "night_sky"],
        "mood": ["peaceful", "dreamy"],
        "elements": ["moon", "clouds", "stars"]
      },
      "market_appeal": {
        "demographic_appeal": ["millennials", "music_fans"],
        "display_context": ["bedroom", "office"]
      }
    }
  }
}
```

#### Similar Posters
```ruby
# GET /api/v1/posters/1076/similar
{
  "data": [
    {
      "id": 1234,
      "type": "poster",
      "attributes": {
        "title": "Starlight Serenade",
        "similarity_score": 0.87,
        "matching_attributes": ["color_palette", "mood", "themes"]
      }
    }
  ],
  "meta": {
    "algorithm": "visual_similarity_v1.2",
    "threshold": 0.75
  }
}
```

### Collection Intelligence API

#### Collection Analysis
```ruby
# GET /api/v1/collections/analysis
{
  "data": {
    "type": "collection_analysis",
    "attributes": {
      "total_value_estimate": 2850.00,
      "value_growth": {
        "last_month": 125.00,
        "last_year": 480.00
      },
      "collection_themes": [
        {"theme": "celestial", "count": 8, "percentage": 17.4},
        {"theme": "concert_posters", "count": 23, "percentage": 50.0}
      ],
      "artist_breakdown": [
        {"artist": "Sarah Chen", "count": 3, "value": 450.00}
      ],
      "recommendations": [
        {
          "type": "complete_series",
          "series": "Playing Card Series",
          "missing_count": 2,
          "estimated_cost": 200.00
        }
      ]
    }
  }
}
```

## Error Handling

### Standard Error Format
```ruby
# 400 Bad Request
{
  "errors": [
    {
      "id": "validation_error",
      "status": "400",
      "code": "invalid_parameter",
      "title": "Invalid Parameter",
      "detail": "The 'year' parameter must be a valid integer between 1950 and current year",
      "source": {
        "parameter": "year"
      }
    }
  ]
}

# 404 Not Found
{
  "errors": [
    {
      "id": "not_found",
      "status": "404",
      "code": "poster_not_found",
      "title": "Poster Not Found",
      "detail": "The poster with ID 9999 does not exist"
    }
  ]
}

# 401 Unauthorized
{
  "errors": [
    {
      "id": "unauthorized",
      "status": "401", 
      "code": "invalid_token",
      "title": "Invalid Authentication Token",
      "detail": "The provided API token is invalid or expired"
    }
  ]
}
```

## Rate Limiting

### API Rate Limits
```ruby
# Rate limiting headers
X-RateLimit-Limit: 1000        # Requests per hour
X-RateLimit-Remaining: 987      # Remaining requests
X-RateLimit-Reset: 1623456789   # Reset timestamp

# Rate limit tiers
Free Tier:     100 requests/hour
Basic Tier:    1,000 requests/hour  
Premium Tier:  10,000 requests/hour
Enterprise:    Custom limits
```

### Rate Limit Exceeded Response
```ruby
# 429 Too Many Requests
{
  "errors": [
    {
      "status": "429",
      "code": "rate_limit_exceeded", 
      "title": "Rate Limit Exceeded",
      "detail": "You have exceeded your hourly rate limit of 1000 requests",
      "meta": {
        "retry_after": 3600,
        "limit": 1000,
        "reset_at": "2024-06-15T15:00:00Z"
      }
    }
  ]
}
```

## SDK and Integration Examples

### JavaScript SDK (Planned)
```javascript
// Future JavaScript SDK
import { ArtExchangeAPI } from '@theartexchange/sdk';

const api = new ArtExchangeAPI({
  apiKey: 'your-api-key',
  baseURL: 'https://api.theartexch.com'
});

// Search posters
const posters = await api.posters.search({
  query: 'red rocks',
  year: 2019,
  limit: 25
});

// Manage collection
await api.collections.add({
  posterId: 1076,
  status: 'owned',
  condition: 'mint',
  pricePaid: 125.00
});
```

### Mobile App Integration
```swift
// iOS Swift example
struct PosterAPI {
    static func searchPosters(query: String) async throws -> [Poster] {
        let url = URL(string: "https://api.theartexch.com/api/v1/posters?search=\(query)")!
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(PostersResponse.self, from: data).data
    }
}
```

## Implementation Timeline

### Phase 2 (Q3 2024)
- **Public Poster API** - Read-only access to poster database
- **Collection API** - User collection management
- **Search API** - Advanced filtering and search
- **Authentication** - API token system

### Phase 3 (Q1 2025)
- **Marketplace API** - Buying and selling functionality
- **Transaction API** - Payment and shipping management
- **Analytics API** - Collection insights and trends
- **Webhook System** - Real-time notifications

### Future Enhancements
- **GraphQL API** - Flexible query interface
- **Mobile SDKs** - Native iOS and Android libraries
- **Third-party Integrations** - eBay, PayPal, shipping providers
- **Real-time Features** - WebSocket connections for live updates

---

*This API documentation represents the planned architecture for The Art Exchange API system. Implementation will follow the phased development approach outlined in the main project roadmap.*