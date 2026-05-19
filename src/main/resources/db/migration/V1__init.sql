-- V1__init.sql

CREATE DATABASE IF NOT EXISTS alanya_db;
USE alanya_db;

-- Table des pays
CREATE TABLE pays (
    idPays INT PRIMARY KEY AUTO_INCREMENT,
    libelle VARCHAR(100),
    prefix VARCHAR(4),
    timeZone VARCHAR(100),
    decalageHoraire INT
);

-- Table des utilisateurs
CREATE TABLE users (
    alanyalD INT PRIMARY KEY AUTO_INCREMENT,
    nom VARCHAR(60) NOT NULL,
    pseudo VARCHAR(80),
    alanyaPhone VARCHAR(10) UNIQUE NOT NULL,
    idPays INT,
    email VARCHAR(255) UNIQUE,
    password VARCHAR(255) NOT NULL,
    avatar_url VARCHAR(255),
    type_compte SMALLINT DEFAULT 1,
    is_online TINYINT(1) DEFAULT 0,
    last_seen DATETIME,
    exclus TINYINT(1) DEFAULT 0,
    in_call TINYINT(1) DEFAULT 0,
    biometric TINYINT(1) DEFAULT 0,
    fcm_token VARCHAR(255),
    device_ID VARCHAR(255),
    status_msg VARCHAR(100) DEFAULT 'Disponible',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (idPays) REFERENCES pays(idPays)
);

-- Table des conversations
CREATE TABLE conversation (
    conversId BIGINT PRIMARY KEY AUTO_INCREMENT,
    participantID INT NOT NULL,
    isGroup TINYINT(1) DEFAULT 0,
    GroupName VARCHAR(255),
    groupPhoto VARCHAR(255),
    lastMessageText TEXT,
    lastMessageAt DATETIME,
    isPinned TINYINT(1) DEFAULT 0,
    isArchived TINYINT(1) DEFAULT 0,
    unreadCount SMALLINT DEFAULT 0,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (participantID) REFERENCES users(alanyalD) ON DELETE CASCADE
);

-- Table des messages
CREATE TABLE message (
    msgID BIGINT PRIMARY KEY AUTO_INCREMENT,
    senderID INT NOT NULL,
    conversationID INT NOT NULL,
    content TEXT,
    type SMALLINT DEFAULT 0,
    status TINYINT(1) DEFAULT 0,
    sendAt DATETIME,
    readAt DATETIME,
    mediaUrl VARCHAR(255),
    isDeleted TINYINT(1) DEFAULT 0,
    isEdited TINYINT(1) DEFAULT 0,
    replyToID INT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (senderID) REFERENCES users(alanyalD),
    FOREIGN KEY (conversationID) REFERENCES conversation(conversId),
    FOREIGN KEY (replyToID) REFERENCES message(msgID)
);

-- Table des historiques d'appels
CREATE TABLE call_history (
    IDCall BIGINT PRIMARY KEY AUTO_INCREMENT,
    idCaller INT NOT NULL,
    idReceiver INT NOT NULL,
    type SMALLINT DEFAULT 0,
    status SMALLINT DEFAULT 0,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    start_time DATETIME,
    duree INT,
    FOREIGN KEY (idCaller) REFERENCES users(alanyalD),
    FOREIGN KEY (idReceiver) REFERENCES users(alanyalD)
);

-- Table des contacts preferes
CREATE TABLE preferred_contact (
    idPrefContact BIGINT PRIMARY KEY AUTO_INCREMENT,
    alanyalD INT NOT NULL,
    idFriend INT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (alanyalD) REFERENCES users(alanyalD) ON DELETE CASCADE,
    FOREIGN KEY (idFriend) REFERENCES users(alanyalD) ON DELETE CASCADE,
    UNIQUE KEY unique_contact (alanyalD, idFriend)
);

-- Table des status
CREATE TABLE status (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    alanyalD INT NOT NULL,
    type SMALLINT DEFAULT 0,
    text TINYTEXT,
    mediaUrl VARCHAR(255),
    backgroundColor VARCHAR(20),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    expiredAt DATETIME,
    viewedBy INT DEFAULT 0,
    likedBy INT DEFAULT 0,
    FOREIGN KEY (alanyalD) REFERENCES users(alanyalD) ON DELETE CASCADE
);

-- Table des utilisateurs bloques
CREATE TABLE blocked (
    idBlock BIGINT PRIMARY KEY AUTO_INCREMENT,
    alanyalD INT NOT NULL,
    idCallerBlock INT NOT NULL,
    dateBlock DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (alanyalD) REFERENCES users(alanyalD) ON DELETE CASCADE,
    FOREIGN KEY (idCallerBlock) REFERENCES users(alanyalD) ON DELETE CASCADE,
    UNIQUE KEY unique_block (alanyalD, idCallerBlock)
);

-- Table des acces utilisateurs
CREATE TABLE access_alanya (
    idLogin BIGINT PRIMARY KEY AUTO_INCREMENT,
    alanyalD INT NOT NULL,
    device VARCHAR(255),
    dateLogin DATETIME DEFAULT CURRENT_TIMESTAMP,
    ipAddress VARCHAR(255),
    os_system VARCHAR(255),
    FOREIGN KEY (alanyalD) REFERENCES users(alanyalD) ON DELETE CASCADE
);

-- Table des meetings (appels de groupe)
CREATE TABLE meeting (
    idMeeting BIGINT PRIMARY KEY AUTO_INCREMENT,
    idOrganiser INT NOT NULL,
    start_time DATETIME,
    duree INT,
    object VARCHAR(255),
    room VARCHAR(100),
    isEnd TINYINT(1) DEFAULT 0,
    type_media TINYINT(1) DEFAULT 0,
    FOREIGN KEY (idOrganiser) REFERENCES users(alanyalD)
);

-- Table des participants aux meetings
CREATE TABLE participant (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    idMeeting BIGINT NOT NULL,
    idParticipant INT NOT NULL,
    status TINYINT DEFAULT 0,
    start_time DATETIME,
    connecte TINYINT DEFAULT 0,
    duree INT,
    FOREIGN KEY (idMeeting) REFERENCES meeting(idMeeting) ON DELETE CASCADE,
    FOREIGN KEY (idParticipant) REFERENCES users(alanyalD)
);

-- Insertion donnees pays de base
INSERT INTO pays (libelle, prefix, timeZone, decalageHoraire) VALUES
('Cameroun', '+237', 'Africa/Douala', 1),
('France', '+33', 'Europe/Paris', 1),
('Canada', '+1', 'America/Toronto', -5),
('Belgique', '+32', 'Europe/Brussels', 1),
('Suisse', '+41', 'Europe/Zurich', 1),
('Côte d\'Ivoire', '+225', 'Africa/Abidjan', 0),
('Sénégal', '+221', 'Africa/Dakar', 0),
('Maroc', '+212', 'Africa/Casablanca', 1),
('Tunisie', '+216', 'Africa/Tunis', 1),
('RD Congo', '+243', 'Africa/Kinshasa', 1);

-- Insertion utilisateur demo
INSERT INTO users (nom, pseudo, alanyaPhone, email, password, type_compte, is_online, status_msg) VALUES
('Utilisateur Demo', 'demo', '690000000', 'demo@alanya.com', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EfMlqYy4XjMqXqXqXqXqXq', 1, 1, 'Disponible');