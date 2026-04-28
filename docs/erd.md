# Echelon Database ERD
erDiagram
    USERS {
        int user_id PK
        string first_name
        string last_name
        string role
        string profile_image_url
        int points
        bool dark_mode
    }

    VEHICLE_CLASSES {
        int class_id PK
        string name
        string image_url
    }

    VEHICLES {
        int vehicle_id PK
        int class_id FK
        string name
        string address
        string attributes
        string image_url
        string image_credits
        decimal distance_km
        decimal rating
        decimal hourly_rate
    }

    ADD_ONS {
        int add_on_id PK
        int vehicle_id FK
        string name
        string description
        decimal price
        string image_url
    }

    ORDERS {
        int order_id PK
        int user_id FK
        int vehicle_id FK
        string driver_name
        date pickup_date
        time pickup_time
        string trip_type
        string rental_unit
        int rental_length
        decimal base_rate
        decimal discount_amount
        string discount_code
        datetime created_at
    }

    ORDER_ADD_ONS {
        int order_add_on_id PK
        int order_id FK
        int add_on_id FK
        int quantity
        decimal unit_price
    }

    POSTS {
        int post_id PK
        int user_id FK
        string profile_image_url
        string comment
        string timestamp_label
    }

    USERS ||--o{ ORDERS : places
    VEHICLE_CLASSES ||--o{ VEHICLES : categorizes
    VEHICLES ||--o{ ADD_ONS : offers
    VEHICLES ||--o{ ORDERS : booked_in
    ORDERS ||--o{ ORDER_ADD_ONS : contains
    ADD_ONS ||--o{ ORDER_ADD_ONS : selected_as
    USERS ||--o{ POSTS : writes
