CREATE TYPE content_type AS ENUM ('text', 'image');

CREATE TABLE messages (
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    message_id BIGSERIAL PRIMARY KEY NOT NULL,
    convo_id BIGINT,
    content VARCHAR(4096) NOT NULL,
    type content_type NOT NULL,
    sender_name VARCHAR(32),
    sender_avatar VARCHAR(16)
);

CREATE TABLE conversations (
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    convo_id BIGSERIAL PRIMARY KEY NOT NULL,
    name VARCHAR(128) NOT NULL
);

CREATE OR REPLACE FUNCTION update_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.* IS DISTINCT FROM OLD.* THEN
        NEW.updated_at = NOW(); 
        RETURN NEW;
    ELSE
        RETURN OLD;
    END IF;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION update_conversation_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE conversations
    SET updated_at = NOW()
    WHERE convo_id = NEW.convo_id;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_timestamp_messages BEFORE UPDATE ON messages
FOR EACH ROW EXECUTE PROCEDURE update_timestamp();

CREATE TRIGGER update_timestamp_conversations BEFORE UPDATE ON conversations
FOR EACH ROW EXECUTE PROCEDURE update_timestamp();

CREATE TRIGGER update_conversation_timestamp_trigger AFTER INSERT ON messages
FOR EACH ROW EXECUTE PROCEDURE update_conversation_timestamp();