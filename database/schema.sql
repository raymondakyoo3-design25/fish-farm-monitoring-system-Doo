-- FISH FARM MONITORING SYSTEM
-- Database Schema - Version 1

CREATE TABLE farms (
    id SERIAL PRIMARY KEY,
    farm_name VARCHAR(150) NOT NULL,
    location VARCHAR(150),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    full_name VARCHAR(150) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    password_hash TEXT NOT NULL,
    role VARCHAR(50) DEFAULT 'operator',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE species (
    id SERIAL PRIMARY KEY,
    species_name VARCHAR(100) NOT NULL,
    scientific_name VARCHAR(150),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE cages (
    id SERIAL PRIMARY KEY,
    farm_id INTEGER NOT NULL REFERENCES farms(id),
    cage_code VARCHAR(50) NOT NULL,
    length_m DECIMAL(10,2),
    width_m DECIMAL(10,2),
    depth_m DECIMAL(10,2),
    volume_m3 DECIMAL(12,2),
    status VARCHAR(30) DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE feed_types (
    id SERIAL PRIMARY KEY,
    feed_name VARCHAR(100) NOT NULL,
    manufacturer VARCHAR(100),
    pellet_size_mm DECIMAL(5,2),
    protein_percent DECIMAL(5,2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE fish_batches (
    id SERIAL PRIMARY KEY,
    batch_code VARCHAR(100) UNIQUE NOT NULL,
    species_id INTEGER NOT NULL REFERENCES species(id),
    cage_id INTEGER NOT NULL REFERENCES cages(id),
    stocking_date DATE NOT NULL,
    initial_number INTEGER NOT NULL,
    initial_abw_g DECIMAL(10,3) NOT NULL,
    status VARCHAR(30) DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE stocking_events (
    id SERIAL PRIMARY KEY,
    batch_id INTEGER NOT NULL REFERENCES fish_batches(id),
    date DATE NOT NULL,
    number_stocked INTEGER NOT NULL,
    abw_g DECIMAL(10,3),
    source VARCHAR(150),
    notes TEXT
);

CREATE TABLE sampling_records (
    id SERIAL PRIMARY KEY,
    batch_id INTEGER NOT NULL REFERENCES fish_batches(id),
    sample_date DATE NOT NULL,
    number_sampled INTEGER NOT NULL,
    total_sample_weight_g DECIMAL(12,2) NOT NULL,
    abw_g DECIMAL(10,3) NOT NULL,
    fish_population INTEGER,
    biomass_kg DECIMAL(12,3),
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE feeding_records (
    id SERIAL PRIMARY KEY,
    batch_id INTEGER NOT NULL REFERENCES fish_batches(id),
    feed_type_id INTEGER REFERENCES feed_types(id),
    feeding_date DATE NOT NULL,
    feed_given_kg DECIMAL(12,3) NOT NULL,
    feed_leftover_kg DECIMAL(12,3) DEFAULT 0,
    feeding_events INTEGER,
    feeding_response VARCHAR(50),
    recorded_by INTEGER REFERENCES users(id),
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE water_quality_records (
    id SERIAL PRIMARY KEY,
    cage_id INTEGER NOT NULL REFERENCES cages(id),
    measurement_time TIMESTAMP NOT NULL,
    temperature_c DECIMAL(6,2),
    dissolved_oxygen_mg_l DECIMAL(6,2),
    ph DECIMAL(5,2),
    ammonia_mg_l DECIMAL(8,4),
    nitrite_mg_l DECIMAL(8,4),
    recorded_by INTEGER REFERENCES users(id),
    notes TEXT
);

CREATE TABLE mortality_records (
    id SERIAL PRIMARY KEY,
    batch_id INTEGER NOT NULL REFERENCES fish_batches(id),
    mortality_date DATE NOT NULL,
    number_dead INTEGER NOT NULL,
    suspected_cause VARCHAR(150),
    action_taken TEXT,
    recorded_by INTEGER REFERENCES users(id),
    notes TEXT
);

CREATE TABLE transfer_records (
    id SERIAL PRIMARY KEY,
    batch_id INTEGER NOT NULL REFERENCES fish_batches(id),
    transfer_date DATE NOT NULL,
    from_cage_id INTEGER REFERENCES cages(id),
    to_cage_id INTEGER REFERENCES cages(id),
    number_transferred INTEGER NOT NULL,
    notes TEXT
);

CREATE TABLE harvest_records (
    id SERIAL PRIMARY KEY,
    batch_id INTEGER NOT NULL REFERENCES fish_batches(id),
    harvest_date DATE NOT NULL,
    number_harvested INTEGER,
    total_weight_kg DECIMAL(12,3),
    average_weight_g DECIMAL(10,3),
    notes TEXT,
    recorded_by INTEGER REFERENCES users(id)
);