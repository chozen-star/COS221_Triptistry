# Tripistry — Complete Project Documentation

COS 221 Practical Assignment 5 | University of Pretoria | May 2026

---

## Table of Contents

1. [Project Overview](#project-overview)
2. [Setup Instructions](#setup-instructions)
3. [Architecture](#architecture)
4. [Database Schema](#database-schema)
5. [Page-by-Page Documentation](#page-by-page-documentation)
6. [Traveller Dashboard — All Tabs](#traveller-dashboard)
7. [Agency Dashboard — All Tabs](#agency-dashboard)
8. [API Endpoints](#api-endpoints)
9. [Security Features](#security-features)
10. [Design Decisions & Updates Log](#design-decisions)
11. [Bonus Features](#bonus-features)
12. [Sample Data Summary](#sample-data)
13. [Demo Run-Through Script](#demo-script)
14. [File Structure](#file-structure)

---

## Project Overview

Tripistry is a web-based travel package marketplace connecting travellers with travel agencies. The platform enforces two distinct user roles with completely separate interfaces, different permissions, and role-gated access control.

**Travellers** browse destinations, compare packages across multiple agencies, book trips with confirmation modals, enrol in group trips, and leave reviews on packages and individual components (destinations, restaurants, accommodations).

**Agencies** create and manage travel packages by selecting destinations, flights, accommodations, restaurants, and attractions through name-based checkbox lists. They also coordinate group trips with enrolment tracking, view who booked their packages, and monitor trip fill rates.

---

## Setup Instructions

### Requirements
- XAMPP (Apache on port 8080 + MySQL)
- PHP 8.0+
- Modern web browser
- MySQL Workbench (optional — for data import)

### Installation Steps

1. Start **Apache** and **MySQL** in XAMPP Control Panel (both green)
2. Open `http://localhost:8080/phpmyadmin` → Import tab → choose `database.sql` → Go
3. Or open MySQL Workbench, connect to `127.0.0.1:3307`, and run `database.sql`
4. Place the entire `Tripistry` folder at `C:\xampp\htdocs\`
5. Open `http://localhost:8080/Tripistry/index.html`

### Database Configuration
File: `api/config.php`
- DB_HOST: `localhost` (or `127.0.0.1`)
- DB_PORT: `3306` (XAMPP) or `3307` (MySQL Workbench MariaDB)
- DB_NAME: `tripistry`
- DB_USER: `root`
- DB_PASS: empty (XAMPP default)

### Default Test Accounts

| Role | Login With | Password |
|------|-----------|----------|
| Traveller | james@gmail.com | Travel123 |
| Traveller | aisha@gmail.com | Explore99 |
| Traveller | thabo@gmail.com | Safari25 |
| Traveller | emma@gmail.com | Package42 |
| Traveller | liam@gmail.com | Trip2026 |
| Agency | Wanderlust Travel | Tripistry1 |
| Agency | Global Adventures | Travel2026 |
| Agency | Budget Roamers | Safari2026 |
| Agency | Safari Experts | Package01 |
| Agency | African Explorers | Explore25 |

---

## Architecture

**Frontend**: Vanilla HTML5, CSS3, JavaScript (no frameworks — per assignment constraint). Single-page application (SPA) architecture for dashboards with tab-based navigation. All API calls use `fetch()` with `credentials: 'same-origin'` for session cookie transmission.

**Backend**: PHP 8.2 with PDO for database access. Each API endpoint is a standalone PHP file. No routing framework — direct file references keep the codebase simple and debuggable. JSON responses via a shared `respond()` helper.

**Database**: MariaDB 10.4 with 22 tables including 4 ISA specialisation tables, 7 M:N junction tables, and 2 multivalued attribute tables. All foreign keys use InnoDB with CASCADE or SET NULL deletion.

---

## Database Schema — 22 Tables

### Core Entities (9)
| Table | Primary Key | Key Foreign Keys |
|-------|------------|-----------------|
| `traveler` | TravelerID | — |
| `agency` | AgencyID | — |
| `destination` | DestinationID | — |
| `airline` | AirlineID | — |
| `flight` | FlightID | AirlineID → airline |
| `accommodation` | AccommodationID | DestinationID → destination |
| `touristattraction` | AttractionID | DestinationID → destination |
| `restaurant` | RestaurantID | DestinationID → destination |
| `travelpackage` | PackageID | AgencyID → agency |
| `grouptrip` | GroupTripID | AgencyID → agency |
| `review` | ReviewID | PackageID/DestinationID/RestaurantID/AccommodationID (optional) + TravellerID |
| `booking` | — (TravellerID only) | TravellerID → traveler |

### ISA Specialisation — Accommodation Subtypes (3)
| Table | Unique FK | Extra Columns |
|-------|----------|--------------|
| `hotel` | AccommodationID → accommodation | BedType, Stars |
| `resort` | AccommodationID → accommodation | ResortType |
| `apartment` | AccommodationID → accommodation | Bedrooms |

### Multivalued Attributes (2)
| Table | FK | Attribute |
|-------|-----|-----------|
| `pack_cuisine` | RestaurantID → restaurant | Cuisine |
| `rest_location` | RestaurantID → restaurant | Location |

### Junction Tables — M:N Relationships (7)
| Table | Links |
|-------|-------|
| `packages` | TravelerID + PackageID (traveller bookings) |
| `package_dest` | PackageID + DestinationID |
| `includes` | PackageID + FlightID |
| `package_attr` | PackageID + AttractionID |
| `package_rest` | PackageID + RestaurantID |
| `package_accom` | PackageID + AccommodationID |
| `group_enrolment` | GroupTripID + TravellerID |

### Utility (1)
| Table | Purpose |
|-------|---------|
| `login_attempts` | Rate limiting — tracks failed login attempts per identifier with timestamp |

---

## Page-by-Page Documentation

### index.html — Public Homepage
- **Hero section** with travel imagery, tagline, and search bar
- **Stats bar** showing live counts of agencies, packages, destinations, reviews, and group trips (fetched via API)
- **Destination showcase** — 6 destination cards with country badges and descriptions
- **Featured packages** — 8 package cards sorted by agency rating, each with View and Book buttons
- **Split portal** — side-by-side sections for travellers and agencies with login CTAs
- **Footer** with navigation links
- **Search** passes query to the login page for authenticated use
- All data fetched asynchronously via `fetch()` with `escHtml()` XSS protection

### login-traveller.html / login-agency.html
- Clean split layout — branding on left, form on right
- Agency login uses **Name** as identifier (not email)
- Traveller login uses **Email** as identifier
- Server-side rate limiting: 3 failed attempts = 15-minute lockout per identifier
- Password verification via `password_verify()` (bcrypt)
- On success: session cleared, ID regenerated, CSRF token generated, redirect to dashboard

### register-traveller.html / register-agency.html
- Client-side validation: name length, website format, password minimum length, age (13+)
- Server-side validation: duplicate email/phone/name checks, type enum validation
- Passwords hashed with `password_hash(PASSWORD_BCRYPT)` — bcrypt with automatic salt
- Traveller: passport number optional
- Agency: type restricted to Full Service/Boutique/OTA

### package-details.html — Package Detail View
- **Hero image** — package's own image URL (or fallback Unsplash) as full-width background with gradient overlay
- **Glass-morphism price panel** — translucent blurred box with "FROM" label, large price, "per person", and "Book Now" button (hidden for agencies)
- **Amenity badges** — type, duration, lodging/service/activities labels
- **Agency info** with star rating
- **Itinerary section** — day-by-day plan in styled box with red left accent and shadow
- **Destination cards** — linked destinations with country badges
- **Accommodation cards** — with type labels and prices
- **Flights table** — airline, origin/destination, times, fare
- **Attraction cards** — with type and price
- **Restaurant cards** — with cuisine types and location
- **Back button** — prominent styled button with arrow
- Booking confirmation modal with package summary

---

## Traveller Dashboard — All 10 Tabs

### 1. Packages
- Browse all 25 packages from all 5 agencies
- **Sorting**: price (asc/desc), rating (highest first), duration (asc/desc)
- **Filtering**: type (Bundled/Individual), price range, duration range, destination name dropdown, minimum rating
- **Each card shows**: package image (custom URL or Unsplash fallback), type badge, price badge overlay on image, duration badge, agency name, star rating, package name, amenity pills (Lodging/Service/Activities), View button → package-details.html, Book button → confirmation modal with package name, agency, and price
- Package image URLs set by agencies — if empty, uses curated Unsplash photos with onerror fallback

### 2. My Bookings
- **Package bookings**: card with image, package name, agency, price, Review button (inline form), Cancel button (confirmation modal)
- **Group trip enrolments**: card with trip image, name, agency, date range, enrolled badge, Leave button
- **Cancel booking**: styled confirmation modal → DELETE request → removes from database, toasts success/error
- **Package review**: inline form with rating (1-5) and feedback → POST to reviews.php with PackageID

### 3. Reviews
- **Browse section**: pick type (Package/Destination/Restaurant/Accommodation) → pick specific item by NAME from dropdown → see all reviews with star rating, feedback text, reviewer name, and date
- **Write section**: pick type → pick item by NAME → rating (1-5) + feedback → submit
- Four target types supported: Package, Destination, Restaurant, Accommodation
- Exactly one target required per review (validated server-side)

### 4. Group Trips
- Browse all 15 group trips across 5 agencies
- **Each card**: image (custom URL or Unsplash), OPEN/FULL badge, agency name, enrolment count, trip name, itinerary preview, date range, price per person
- **View button** → styled detail panel with 4 stat cards (start date, capacity with enrolled/max, duration in days, price in dark card showing R X,XXXpp or "Free")
- **Enrol button** → confirmation popup with trip name → POST enrol → appears on My Bookings
- Full/inactive trips show "Full" badge instead of Enrol button

### 5. Destinations
- Browse all 7 destinations with cards showing country badge, name, region, restaurant count, description preview
- **Toggle checkbox**: "Only from my packages" — filters to destinations in booked packages only
- Uses data caching for detail views

### 6. Flights
- Shows **only flights from booked packages** — not all 8 flights
- Table view: ID, origin, destination, departure/arrival times, fare, airline name
- If no bookings, shows guidance message

### 7. Accommodations
- Browse all 10 accommodations with cards showing type label (Hotel/Resort/Apartment), location name, price per night
- **Toggle checkbox**: "Only from my packages" — filters to accommodations linked to booked packages
- Cards fetched from `accommodations.php` (all) or `packages.php?id=X` (booked only)

### 8. Attractions
- Browse all 8 tourist attractions with cards showing type tag, location, name, price
- **Toggle checkbox**: "Only from my packages"

### 9. Restaurants
- Browse all 8 restaurants with cards showing price range tag, name, cuisine types, location
- **Toggle checkbox**: "Only from my packages"
- Cuisine and location data from `pack_cuisine` and `rest_location` tables

### 10. Logout
- Calls `logout.php` — destroys session, expires cookie
- Redirects to traveller login

---

## Agency Dashboard — All 10 Tabs

### 1. My Packages
- Filter bar: type, sort, price range, duration, destination name dropdown
- Table with alternating row colors: ID, package name, type, price, duration, includes column (bold comma-separated), actions column
- **Create button** → form with:
  - Package name text input
  - Type dropdown (Bundled/Individual)
  - Price number input
  - Duration (days) number input
  - Image URL with **live preview** — thumbnail appears as you type, broken images show error
  - Itinerary textarea for day-by-day plan
  - 5 **name-based checkbox lists**: Destinations, Flights, Accommodations, Restaurants, Attractions (all fetched from APIs, displayed by name not ID)
  - Three amenity toggles: Lodging, Service, Activities
- **Edit** — pre-populates form with existing data, pulls accommodation_ids/flight_ids etc. from API
- **Update** — PUT request with all fields + junction table replacements
- **Delete** — styled confirmation modal showing package name → cascading delete of all junction rows + travelpackage row
- **View** — opens package-details.html (booking button hidden for agencies)
- Destination filter dropdown cleared before re-population to prevent duplicates

### 2. Bookings
- **Package Bookings section**: table with package ID, name, type, price, duration, traveller name, traveller email
- **Group Trip Enrolments section**: table with trip ID, name, enrolled/max, start/end dates
- Both filtered by the logged-in agency's ID
- "No bookings yet" message when empty

### 3. Reviews
- Browse reviews by type with name-based dropdown
- Displays star rating, feedback, reviewer name, date with proper spacing

### 4. Group Trips
- Table with trip ID, name, max size, enrolled count, start/end dates, itinerary preview, actions
- **Create button** → form with: trip name, max size, price per person, start/end dates, image URL with live preview, itinerary textarea
- **Edit** — pre-populates from API
- **Update** — PUT with ownership check
- **Delete** — confirmation modal with trip name → cascading delete of enrolments + trip row
- Ownership enforced: agency can only modify their own trips (403 if mismatched)

### 5-9. Browse Tabs
- Destinations, Flights, Accommodations, Attractions, Restaurants — all showing full lists
- Cards with images (custom Unsplash pools per type) and descriptive metadata
- All data escaped with `esc()` before rendering

---

## API Endpoints — Complete Reference

### Public Endpoints (No Authentication Required)
| Endpoint | Method | Query Parameters | Returns |
|----------|--------|-----------------|---------|
| `destinations.php` | GET | `?id=`, `?country=` | Single object with RestaurantCount or array |
| `flights.php` | GET | `?id=`, `?origin=`, `?destination=`, `?airline_id=` | Flight objects with AirlineName and AirlineCountry |
| `accommodations.php` | GET | `?id=`, `?destination_id=` | Accommodation with AccommodationType (Hotel/Resort/Apartment), subtype details |
| `attractions.php` | GET | `?id=`, `?type=` | Attraction objects |
| `restaurants.php` | GET | `?id=`, `?destination_id=`, `?cuisine=` | Restaurant with CuisineTypes (GROUP_CONCAT) and Locations (GROUP_CONCAT) |
| `packages.php` | GET | `?id=`, `?sort=`, `?type=`, `?min_price=`, `?max_price=`, `?destination_id=`, `?min_rating=`, `?min_duration=`, `?max_duration=`, `?agency_id=` | Package with linked destinations, flights, attractions, restaurants, accommodations |
| `grouptrips.php` | GET | `?id=`, `?agency_id=`, `?enrolled_by=` | Group trip with AgencyName and CurrentEnrolment |
| `reviews.php` | GET | `?package_id=`, `?destination_id=`, `?restaurant_id=`, `?accommodation_id=` | Reviews with TravellerName, date formatted as DATE only |
| `login_agency.php` | POST | Body: Name, password | Session set with user_id, user_type='agency', name, csrf_token |
| `login_traveller.php` | POST | Body: Email, password | Session set with user_id, user_type='traveller', name, csrf_token |
| `register_agency.php` | POST | Body: Name, Website, Type, password | 201 with agency registered message |
| `register_traveller.php` | POST | Body: Name, Lname, Email, password, PhoneNumber, DOB, PassportNumber | 201 with traveller registered message |

### Authenticated Endpoints
| Endpoint | Method | Role Required | Parameters |
|----------|--------|--------------|------------|
| `session.php` | GET | Any | Returns user_id, user_type, name, csrf_token |
| `logout.php` | GET | Any | Destroys session, expires cookie |
| `packages.php` | POST | Agency | JSON body with Name, Type, Price, IncludesLodging/Service/Activities, DurationDays, Itinerary, ImageURL, destination_ids[], flight_ids[], attraction_ids[], restaurant_ids[], accommodation_ids[] |
| `packages.php` | PUT | Agency | Same as POST, all fields optional, `?id=` required |
| `packages.php` | DELETE | Agency | `?id=` — cascading delete of all junction rows |
| `bookings.php` | GET | Any | Agency sees own packages' bookings; traveller sees own bookings |
| `bookings.php` | POST | Traveller | JSON body: PackageID. Checks for duplicates (409 if already booked) |
| `bookings.php` | DELETE | Traveller | `?package_id=` — removes from packages table, removes booking if last one |
| `grouptrips.php` | POST | Agency | JSON body: Name, MaxSize, Price, Itinerary, StartDate, EndDate, ImageURL |
| `grouptrips.php` | PUT | Agency | Same as POST, `?id=` required, ownership check enforced |
| `grouptrips.php` | DELETE | Agency | `?id=` — deletes enrolments + trip, ownership check |
| `grouptrips.php?action=enrol` | POST | Traveller | JSON body: GroupTripID. Checks full (400), duplicate (409) |
| `grouptrips.php` | DELETE | Traveller | `?id=` — leaves trip, decrements CurrentEnrolment |
| `reviews.php` | POST | Traveller | JSON body: StarRating (1-5), Feedback, one of PackageID/DestinationID/RestaurantID/AccommodationID |

---

## Security Features — Complete Details

### Password Hashing — bcrypt
**Algorithm**: `password_hash($password, PASSWORD_BCRYPT)` with automatic salt generation.
**Verification**: `password_verify($password, $storedHash)` — constant-time comparison resistant to timing attacks.
**Why bcrypt over SHA-256**: bcrypt is intentionally slow (configurable cost factor of 10). Each hash includes a unique 22-character salt. SHA-256 is a general-purpose hash designed for speed — unsuitable for password storage. Two identical passwords produce identical SHA-256 hashes (no salt), making rainbow table attacks trivial. bcrypt produces different hashes for identical passwords.

### SQL Injection Prevention
**100% of database queries** use PDO prepared statements with parameter binding. No query concatenates user input. Example:
```php
$stmt = $pdo->prepare('SELECT * FROM traveler WHERE Email = ?');
$stmt->execute([$_POST['Email']]);
```
Even SQL injection payloads like `' OR '1'='1` are treated as literal string values, not SQL code. Verified by the testing guide — login with `Email=' OR '1'='1` returns 401.

### Login Rate Limiting
- **Table**: `login_attempts(AttemptID, Identifier, AttemptTime, Success)`
- **Logic**: Before verifying password, count failed attempts (Success=0) in the last 15 minutes for the identifier (email or agency name). If count ≥ 3, return HTTP 429 "Too many attempts."
- **Failed attempt**: INSERT with Success=0
- **Successful attempt**: INSERT with Success=1
- **Window**: 15 minutes — after this period, failed attempts expire naturally

### Session Management
- **Fixation prevention**: `session_regenerate_id(true)` called on every login — old session ID invalidated, new ID generated
- **Clearing**: `$_SESSION = []` before setting new values prevents stale data from previous logins
- **Cookie expiry**: On logout, session cookie explicitly expired via `setcookie()` with past timestamp
- **Role guards**: Both dashboards check `user_type` on load — wrong role redirects to correct login page

### Cross-Site Request Forgery (CSRF)
- Token generated on login: `bin2hex(random_bytes(32))` — 64-character hex string
- Sent via `X-CSRF-Token` header on every fetch request from both dashboards
- Token returned by `session.php` and stored in JavaScript variable `csrfToken`
- Validation function `validateCsrf()` defined in `auth.php` with `hash_equals()` for timing-safe comparison
- **Currently disabled** (no-op) for testing — can be enabled by uncommenting the function body

### XSS Prevention
- **`esc()` helper function** defined in both dashboards and package-details.html:
  ```javascript
  function esc(text) {
    if (!text) return '';
    const div = document.createElement('div');
    div.textContent = text;
    return div.innerHTML;
  }
  ```
- All user-generated content (package names, agency names, review feedback, destination descriptions, etc.) is passed through `esc()` before being injected into innerHTML
- The function creates a temporary DOM element, sets textContent (safe — no HTML interpretation), and reads innerHTML (properly escaped)

### Access Control
- **API level**: `requireRole('agency')` and `requireRole('traveller')` middleware functions check session user_type
- **Dashboard level**: JavaScript `init()` checks `r.data.user_type` and redirects if wrong
- **Ownership**: PUT/DELETE on packages and group trips verify `AgencyID` matches logged-in user

---

## Design Decisions & Updates Log

### Why name-based dropdowns instead of ID inputs
Agency package creation originally used text inputs where agencies typed numeric IDs (e.g., "1,2,3") for destinations, flights, etc. This was error-prone and required memorising database IDs. Replaced with checkbox lists that fetch entity names from the API — "Cape Town (South Africa)" instead of "1", "JHB → CPT (South African Airways)" instead of "1". Improves usability and eliminates ID lookup errors.

### Why separate `package_dest` and `package_accom` tables
Accommodations were originally linked to packages indirectly through destinations (accommodation → destination → package_dest). This was inflexible — a package couldn't include an accommodation without including its destination. Added `package_accom` junction table for direct accommodation-to-package linking, giving agencies precise control.

### Why `DestinationID` on `accommodation` table
The original database export lacked this column. Every accommodation query failed because the PHP code JOINs on `a.DestinationID`. Added the column with FOREIGN KEY constraint and populated values matching the sample data.

### Why `Price` on `grouptrip` table
Group trips originally had no pricing. Travellers couldn't see what they'd pay before enrolling. Added optional `Price DECIMAL(10,2)` column — shows on trip cards as "R4,200pp" and in the detail view stat card. Null = free trip.

### Why `Itinerary` on `travelpackage` table
Packages originally had no day-by-day plan. The package detail page was incomplete without showing what happens each day. Added `Itinerary TEXT` column — agencies write the plan in a textarea, displayed as formatted text in a styled box on the detail page.

### Why `PackageID` on `review` table
Reviews originally only targeted destinations, restaurants, and accommodations. Travellers couldn't review a package as a whole. Added optional `PackageID` FK — now reviews can target any of four entity types. Package reviews appear on the My Bookings page via an inline form.

### Why `ImageURL` on both `travelpackage` and `grouptrip`
Both entities now support custom image URLs with live preview in forms. If empty or broken, the system falls back to curated Unsplash images via `onerror` handlers. URL validation checks for `http://` or `https://` prefix before submission.

### Why `login_attempts` table
Added for bonus security marks. Tracks failed login attempts per identifier (email or agency name) with a 15-minute sliding window. Lockout at 3 failures. Demonstrates understanding of brute-force protection beyond basic authentication.

### Why `booking` table has no `BookingID` primary key
Matches the original database design where booking is treated as a dependent entity on traveller. The `packages` junction table handles the package-to-traveller relationship. `booking` stores the status and date of the overall booking relationship, not individual package bookings. This design was maintained for spec compliance.

### Why toast notifications instead of `alert()`
Browser `alert()` dialogs are unstyled, blocking, and unprofessional. Custom toast system with CSS animations (green success, red error, teal info) provides non-blocking feedback that auto-dismisses after 3 seconds. Implemented via `#toastContainer` with `position: fixed` and flexbox column layout.

### Why styled confirmation modals instead of `confirm()`
Browser `confirm()` dialogs cannot be styled and look inconsistent with the site design. Custom modal system using `modal-overlay` CSS class with centered `modal-box`, title, message, and two styled buttons. Used for all destructive actions: delete package, delete trip, cancel booking, leave group trip.

---

## Bonus Features — Task 11

### Category 1: Enhanced UI/UX
1. **Toast notification system** — animated success/error/info messages on all user actions
2. **Styled confirmation modals** — replace all browser `confirm()` dialogs with site-themed popups
3. **Live image preview** — typing an image URL in agency forms shows a real-time thumbnail
4. **Skeleton loading** — pulsing indicators during API fetches on both dashboards
5. **Detail modals** — clicking browse cards opens overlay with full entity information
6. **Hover animations** — cards lift on hover with smooth CSS transitions
7. **Stat cards** — group trip detail view shows 4 styled stat cards (date, capacity, duration, price)
8. **Glass-morphism** — package detail price panel uses backdrop blur for modern aesthetic
9. **Hero image** — package detail page uses the package's own image as a full-width hero background
10. **Image onerror fallback** — all images gracefully fall back to Unsplash alternatives

### Category 2: Security Features
1. **bcrypt password hashing** — `PASSWORD_BCRYPT` with automatic salt, documented rationale for choice
2. **Login rate limiting** — `login_attempts` table, 3 failed attempts = 15-minute lockout, HTTP 429 response
3. **XSS prevention** — `esc()` helper on all user-generated content before DOM injection
4. **Session fixation prevention** — `session_regenerate_id(true)` + `$_SESSION = []` on every login
5. **Session management** — proper cookie expiry on logout via `setcookie()` with past timestamp
6. **Role-based access control** — `requireRole()` middleware + dashboard JavaScript guards
7. **SQL injection prevention** — 100% PDO prepared statements, verified via testing guide

### Category 3: Query Optimisation (Task 7)
- Composite indexes on `travelpackage(Price)`, `travelpackage(AgencyID)`
- EXPLAIN analysis documented in PROJECT_REPORT.md with before/after comparison
- Indexes eliminate full table scans and filesort on common package listing queries
- Estimated 40-60% improvement for filtered listing queries

---

## Sample Data Summary

The database contains a complete, realistic dataset for demonstration:

| Entity | Count | Details |
|--------|-------|---------|
| Travellers | 5 | With varied names, emails, phone numbers, dates of birth |
| Agencies | 5 | Wanderlust Travel, Global Adventures, Budget Roamers, Safari Experts, African Explorers |
| Destinations | 7 | Across South Africa, Zimbabwe, Tanzania, Morocco, Mauritius |
| Airlines | 7 | South African Airways, Ethiopian, Kenya Airways, FlySafair, Air Mauritius, Royal Air Maroc, Air Tanzania |
| Flights | 8 | Both outbound and return routes connecting major hubs |
| Accommodations | 10 | 4 hotels, 3 resorts, 3 apartments across all 7 destinations |
| Attractions | 8 | Nature, historical, safari, adventure, cultural, garden types |
| Restaurants | 8 | Price ranges $ to $$$$, each with 2 cuisine types and 1 location |
| Travel Packages | 25 | 5 per agency, mix of Bundled and Individual, prices R3,200-R32,000, 2-14 day durations |
| Group Trips | 15 | 3 per agency, capacities 6-20, prices R1,800-R22,000pp |
| Reviews | 50 | 25 package reviews, 7 destination reviews, 8 restaurant reviews, 10 accommodation reviews |

All junction tables fully populated with realistic links — packages include appropriate destinations, flights, accommodations, restaurants, and attractions.

---

## Demo Run-Through Script (12 minutes)

### Preparation
- XAMPP Apache + MySQL running (green)
- Database imported with all sample data
- Browser open to http://localhost:8080/Tripistry/index.html

### Traveller Demo (4 min)
1. Show public homepage — destinations, packages, stats
2. Login as aisha@gmail.com / Explore99 — show dashboard loads with name
3. Browse Packages — show sort by price, filter by destination "Cape Town"
4. Click View on a package — show hero image, price panel, itinerary, all sections
5. Book the package — show confirmation modal, click confirm, toast appears
6. Go to My Bookings — booking appears, show Review form, leave 5-star review
7. Go to Reviews tab — browse reviews for the package, see the one just left
8. Go to Group Trips — click View on "Kruger Big Five Safari Week", show stat cards
9. Enrol — confirmation popup → enrolled → appears on My Bookings

### Agency Demo (4 min)
1. Logout, login as Wanderlust Travel / Tripistry1
2. Show completely different interface — point out role separation
3. Go to My Packages — show the 5 packages, filter by type
4. Create a package — fill name "Demo Package", price 5000, select Cape Town destination, pick V&A Waterfront Hotel, add a flight, paste an image URL showing preview, write itinerary
5. Create → toast confirms → appears in table
6. Edit the package → change price → Update → table updates
7. Delete → confirmation modal → deleted
8. Go to Group Trips → create a trip with name, size, price, dates
9. Go to Bookings → show package bookings AND group trip enrolment stats

### Security Demo (2 min)
1. Show a PHP file snippet with PDO prepared statement — explain parameter binding
2. Show `requireRole()` in auth.php — explain middleware
3. Point out that traveller dashboard redirects if you try to access it as agency
4. Mention rate limiting: 3 wrong passwords = 15 minute lockout

### Bonus Demo (2 min)
1. Show toast notification when booking — animated, auto-dismissed
2. Show confirmation modal (delete something) — styled, not browser confirm()
3. Show image preview in agency form — paste Unsplash URL
4. Mention query optimisation — indexes on price and agency columns
5. Point out XSS protection — esc() function, all user data safe

---

## File Structure

```
Tripistry/
├── api/                          # 18 PHP backend files
│   ├── config.php                # Database configuration
│   ├── db.php                    # PDO connection (port configurable)
│   ├── auth.php                  # Auth middleware + CSRF + request body parser
│   ├── session.php               # Session state check + CSRF token
│   ├── response.php              # JSON response helper
│   ├── login_agency.php          # Agency auth + rate limiting + bcrypt
│   ├── login_traveller.php       # Traveller auth + rate limiting + bcrypt
│   ├── register_agency.php       # Agency registration + validation
│   ├── register_traveller.php    # Traveller registration + validation
│   ├── logout.php                # Session destroy + cookie expire
│   ├── packages.php              # Package CRUD + filtered listing
│   ├── bookings.php              # Booking create/read/cancel
│   ├── grouptrips.php            # Group trip CRUD + enrol/unenrol
│   ├── reviews.php               # Review submit + filtered retrieval
│   ├── destinations.php          # Destination listing + filter
│   ├── flights.php               # Flight listing + filter
│   ├── accommodations.php        # Accommodation listing + subtype details
│   ├── attractions.php           # Attraction listing
│   └── restaurants.php           # Restaurant listing + cuisine/location
├── index.html                    # Public homepage
├── login-agency.html             # Agency login page
├── login-traveller.html          # Traveller login page
├── register-agency.html          # Agency registration
├── register-traveller.html       # Traveller registration
├── dashboard-agency.html         # Agency SPA dashboard (10 tabs)
├── dashboard-traveller.html      # Traveller SPA dashboard (10 tabs)
├── package-details.html          # Package detail view
├── styles.css                    # Global stylesheet
├── database.sql                  # Complete database dump
├── composer.json                 # PHP dependencies
├── README.md                     # This file
└── docs/                         # Documentation + diagrams
    ├── PROJECT_REPORT.md
    ├── ER_DIAGRAM_SPEC.md
    ├── ER_DIAGRAM.drawio
    ├── RELATIONAL_SCHEMA.drawio
    ├── Agency_Login_Details.docx
    ├── Traveller_Login_Details.docx
    ├── Master_Database_Setup.docx
    ├── Tripistry_Testing_Guide.docx
    └── ... (reference PDFs)
```
