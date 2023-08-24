DROP TABLE IF EXISTS USERS CASCADE;

CREATE TABLE IF NOT EXISTS USERS
(
    id    BIGINT        NOT NULL GENERATED BY DEFAULT AS IDENTITY,
    name  VARCHAR(255)  NOT NULL,
    email VARCHAR(512)  NOT NULL,
    CONSTRAINT pk_user PRIMARY KEY (id),
    CONSTRAINT UQ_USER_NAME UNIQUE (name),
    CONSTRAINT UQ_USER_EMAIL UNIQUE (email)
);

DROP TABLE IF EXISTS CATEGORIES CASCADE;

CREATE TABLE IF NOT EXISTS CATEGORIES
(
    id    BIGINT        NOT NULL GENERATED BY DEFAULT AS IDENTITY,
    name  VARCHAR(50)   UNIQUE,
    CONSTRAINT pk_categories PRIMARY KEY (id)
);

DROP TABLE IF EXISTS LOCATIONS CASCADE;

CREATE TABLE IF NOT EXISTS LOCATIONS
(
    id    BIGINT NOT NULL GENERATED BY DEFAULT AS IDENTITY,
    lat   FLOAT,
    lon   FLOAT,
    CONSTRAINT pk_locations PRIMARY KEY (id)
);

DROP TABLE IF EXISTS EVENTS CASCADE;

CREATE TABLE IF NOT EXISTS EVENTS
(
    id                 BIGINT                                    NOT NULL GENERATED BY DEFAULT AS IDENTITY,
    annotation         VARCHAR(2000)                             NOT NULL,
    category_id        BIGINT                                    NOT NULL,
  confirmed_requests BIGINT,
    created_on         TIMESTAMP WITHOUT TIME ZONE               NOT NULL,
    description        VARCHAR(7000)                             NOT NULL,
    event_date         TIMESTAMP WITHOUT TIME ZONE               NOT NULL,
    initiator_id       BIGINT                                    ,
    location_id        BIGINT                                    NOT NULL,
    paid               BOOLEAN,
    participant_limit  INTEGER,
    published_on       TIMESTAMP WITHOUT TIME ZONE,
    request_moderation BOOLEAN,
    state              VARCHAR(20)                               NOT NULL,
    title              VARCHAR(120)                              NOT NULL,
   -- views              BIGINT,

    CONSTRAINT pk_events PRIMARY KEY (id),
    CONSTRAINT fk_category_events FOREIGN KEY (category_id) references CATEGORIES (id) on delete cascade,
    CONSTRAINT fk_user_events FOREIGN KEY (initiator_id) references USERS (id) on delete cascade,
    CONSTRAINT fk_location_events FOREIGN KEY (location_id) references LOCATIONS (id) on delete cascade
);

DROP TABLE IF EXISTS REQUESTS CASCADE;

CREATE TABLE IF NOT EXISTS REQUESTS
(
    id           BIGINT                                    NOT NULL GENERATED BY DEFAULT AS IDENTITY,
    created      TIMESTAMP WITHOUT TIME ZONE               NOT NULL,
    event_id     BIGINT                                    NOT NULL,
    requester_id BIGINT                                    NOT NULL,
    status       VARCHAR                                   NOT NULL,

    CONSTRAINT pk_requests PRIMARY KEY (id),
    CONSTRAINT fk_events_requests FOREIGN KEY (event_id) references EVENTS (id) on delete cascade,
    CONSTRAINT fk_user_requests FOREIGN KEY (requester_id) references USERS (id) on delete cascade,
    CONSTRAINT UQ_REQUESTER_ID_BY_EVENT_ID UNIQUE (requester_id, event_id)
);

DROP TABLE IF EXISTS COMPILATIONS CASCADE;

CREATE TABLE IF NOT EXISTS COMPILATIONS
(
    id       BIGINT        NOT NULL GENERATED BY DEFAULT AS IDENTITY,
    pinned   BOOLEAN,
    title    VARCHAR(120)  NOT NULL,
    CONSTRAINT pk_compilation PRIMARY KEY (id),
    CONSTRAINT UQ_COMPILATION_TITLE UNIQUE (title)
);

DROP TABLE IF EXISTS EVENT_COMPILATIONS CASCADE;

CREATE TABLE IF NOT EXISTS EVENT_COMPILATIONS
(
    compilation_id    BIGINT   NOT NULL,
    event_id          BIGINT   NOT NULL,

    CONSTRAINT fk_event_compilation_to_compilations
    FOREIGN KEY (compilation_id) REFERENCES COMPILATIONS (id) ON DELETE CASCADE,
    CONSTRAINT fk_event_compilation_to_events
    FOREIGN KEY (event_id) REFERENCES EVENTS (id) ON DELETE CASCADE
);

