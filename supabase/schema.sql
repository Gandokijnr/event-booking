-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Create users table
CREATE TABLE users (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    email TEXT UNIQUE NOT NULL,
    full_name TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create events table
CREATE TABLE events (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    title TEXT NOT NULL,
    description TEXT,
    date TIMESTAMPTZ NOT NULL,
    venue TEXT NOT NULL,
    image_url TEXT,
    capacity INTEGER NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create ticket_types table
CREATE TABLE ticket_types (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    event_id UUID REFERENCES events(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    description TEXT,
    price DECIMAL(10,2) NOT NULL,
    quantity INTEGER NOT NULL,
    max_per_order INTEGER DEFAULT 4,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create orders table
CREATE TABLE orders (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    user_id UUID REFERENCES users(id),
    status TEXT NOT NULL CHECK (status IN ('pending', 'confirmed', 'cancelled')),
    total_amount DECIMAL(10,2) NOT NULL,
    payment_intent_id TEXT UNIQUE,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create order_items table
CREATE TABLE order_items (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    order_id UUID REFERENCES orders(id) ON DELETE CASCADE,
    ticket_type_id UUID REFERENCES ticket_types(id),
    quantity INTEGER NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create tickets table (actual tickets generated after payment)
CREATE TABLE tickets (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    order_item_id UUID REFERENCES order_items(id),
    ticket_number TEXT UNIQUE NOT NULL,
    qr_code TEXT,
    used BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Insert sample data
INSERT INTO events (id, title, description, date, venue, capacity) VALUES
(
    '123e4567-e89b-12d3-a456-426614174000',
    'Russell Crowe''s Indoor Garden Party',
    'Join us for an unforgettable evening of music, entertainment, and elegance',
    '2025-12-20 19:00:00+00',
    'Enmore Theatre, Sydney',
    1000
);

-- Insert ticket types
INSERT INTO ticket_types (event_id, name, description, price, quantity, max_per_order) VALUES
(
    '123e4567-e89b-12d3-a456-426614174000',
    'Meet after event',
    'Exclusive opportunity to meet after the event with special access',
    300.00,
    100,
    2
),
(
    '123e4567-e89b-12d3-a456-426614174000',
    'Regular',
    'Standard event access with comfortable seating',
    250.00,
    500,
    4
),
(
    '123e4567-e89b-12d3-a456-426614174000',
    'VIP',
    'Premium seating with enhanced event experience',
    500.00,
    200,
    2
),
(
    '123e4567-e89b-12d3-a456-426614174000',
    'Membership Card',
    'Premium membership card with exclusive year-round benefits',
    1200.00,
    50,
    1
);

-- Create indexes for better performance
CREATE INDEX idx_tickets_order_item ON tickets(order_item_id);
CREATE INDEX idx_order_items_order ON order_items(order_id);
CREATE INDEX idx_ticket_types_event ON ticket_types(event_id);
CREATE INDEX idx_orders_user ON orders(user_id);
CREATE INDEX idx_orders_status ON orders(status);

-- Create function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Create triggers for updated_at
CREATE TRIGGER update_users_updated_at
    BEFORE UPDATE ON users
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_events_updated_at
    BEFORE UPDATE ON events
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_ticket_types_updated_at
    BEFORE UPDATE ON ticket_types
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_orders_updated_at
    BEFORE UPDATE ON orders
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Create view for available tickets
CREATE VIEW available_tickets AS
SELECT 
    tt.id,
    tt.event_id,
    e.title as event_title,
    e.date as event_date,
    tt.name as ticket_type,
    tt.price,
    tt.quantity as total_quantity,
    COALESCE(SUM(oi.quantity), 0) as sold_quantity,
    (tt.quantity - COALESCE(SUM(oi.quantity), 0)) as available_quantity
FROM ticket_types tt
JOIN events e ON tt.event_id = e.id
LEFT JOIN order_items oi ON tt.id = oi.ticket_type_id
LEFT JOIN orders o ON oi.order_id = o.id AND o.status != 'cancelled'
GROUP BY tt.id, e.title, e.date;

-- Enable Row Level Security (RLS)
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE order_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE tickets ENABLE ROW LEVEL SECURITY;

-- Create policies
CREATE POLICY "Users can only view their own data"
ON users FOR SELECT
USING (auth.uid() = id);

CREATE POLICY "Users can only view their own orders"
ON orders FOR SELECT
USING (auth.uid() = user_id);

CREATE POLICY "Users can only view their own tickets"
ON tickets FOR SELECT
USING (
    EXISTS (
        SELECT 1 FROM order_items oi
        JOIN orders o ON oi.order_id = o.id
        WHERE tickets.order_item_id = oi.id
        AND o.user_id = auth.uid()
    )
);

-- Functions for ticket operations
CREATE OR REPLACE FUNCTION check_ticket_availability(
    p_ticket_type_id UUID,
    p_quantity INTEGER
) RETURNS BOOLEAN AS $$
DECLARE
    available INTEGER;
BEGIN
    SELECT (tt.quantity - COALESCE(SUM(oi.quantity), 0))
    INTO available
    FROM ticket_types tt
    LEFT JOIN order_items oi ON tt.id = oi.ticket_type_id
    LEFT JOIN orders o ON oi.order_id = o.id AND o.status != 'cancelled'
    WHERE tt.id = p_ticket_type_id
    GROUP BY tt.id, tt.quantity;

    RETURN available >= p_quantity;
END;
$$ LANGUAGE plpgsql;

-- Function to generate ticket numbers
CREATE OR REPLACE FUNCTION generate_ticket_number() 
RETURNS TEXT AS $$
DECLARE
    result TEXT;
BEGIN
    result := UPPER(
        SUBSTRING(MD5(uuid_generate_v4()::TEXT) FROM 1 FOR 8) || '-' ||
        SUBSTRING(MD5(uuid_generate_v4()::TEXT) FROM 1 FOR 4)
    );
    RETURN result;
END;
$$ LANGUAGE plpgsql;