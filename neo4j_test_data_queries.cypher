// ============================================================================
// NEO4J SOCIAL NETWORK - TEST DATA INSERTION QUERIES
// ============================================================================
// 
// Run these queries in Neo4j Browser (http://localhost:7474)
// or using cypher-shell to populate your database with realistic test data
//
// Order matters! Run sections in sequence.
// ============================================================================

// ============================================================================
// SECTION 1: CLEAN UP (Optional - only if you want to start fresh)
// ============================================================================

// WARNING: This deletes ALL data in your database!
// Uncomment only if you want to reset everything

// MATCH (n)
// DETACH DELETE n;

// Verify database is empty
MATCH (n)
RETURN count(n) as total_nodes;


// ============================================================================
// SECTION 2: CREATE CONSTRAINTS AND INDEXES
// ============================================================================

// These ensure data integrity and query performance

CREATE CONSTRAINT user_email_unique IF NOT EXISTS
FOR (u:User) REQUIRE u.email IS UNIQUE;

CREATE CONSTRAINT user_username_unique IF NOT EXISTS
FOR (u:User) REQUIRE u.username IS UNIQUE;

CREATE CONSTRAINT user_id_unique IF NOT EXISTS
FOR (u:User) REQUIRE u.user_id IS UNIQUE;

CREATE CONSTRAINT post_id_unique IF NOT EXISTS
FOR (p:Post) REQUIRE p.post_id IS UNIQUE;

CREATE CONSTRAINT comment_id_unique IF NOT EXISTS
FOR (c:Comment) REQUIRE c.comment_id IS UNIQUE;

// Indexes for faster queries
CREATE INDEX user_created_at IF NOT EXISTS
FOR (u:User) ON (u.created_at);

CREATE INDEX post_created_at IF NOT EXISTS
FOR (p:Post) ON (p.created_at);


// ============================================================================
// SECTION 3: CREATE TEST USERS
// ============================================================================

// Create 10 realistic test users with profiles
// Passwords are all hashed version of "password123"

CREATE (alice:User {
    user_id: 'user-001-alice',
    email: 'alice@example.com',
    username: 'alice_wonder',
    full_name: 'Alice Wonderland',
    bio: 'Software engineer who loves coffee and coding ☕💻',
    password_hash: '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5O3qNq.w6W6gW',
    created_at: localdatetime()
});

CREATE (bob:User {
    user_id: 'user-002-bob',
    email: 'bob@example.com',
    username: 'bob_builder',
    full_name: 'Bob Builder',
    bio: 'Building amazing things with code 🏗️',
    password_hash: '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5O3qNq.w6W6gW',
    created_at: localdatetime()
});

CREATE (carol:User {
    user_id: 'user-003-carol',
    email: 'carol@example.com',
    username: 'carol_creative',
    full_name: 'Carol Creative',
    bio: 'Designer | Artist | Dreamer ✨🎨',
    password_hash: '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5O3qNq.w6W6gW',
    created_at: localdatetime()
});

CREATE (david:User {
    user_id: 'user-004-david',
    email: 'david@example.com',
    username: 'david_data',
    full_name: 'David Data',
    bio: 'Data scientist exploring the world through numbers 📊',
    password_hash: '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5O3qNq.w6W6gW',
    created_at: localdatetime()
});

CREATE (emma:User {
    user_id: 'user-005-emma',
    email: 'emma@example.com',
    username: 'emma_explore',
    full_name: 'Emma Explorer',
    bio: 'Travel blogger | Adventure seeker 🌍✈️',
    password_hash: '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5O3qNq.w6W6gW',
    created_at: localdatetime()
});

CREATE (frank:User {
    user_id: 'user-006-frank',
    email: 'frank@example.com',
    username: 'frank_foodie',
    full_name: 'Frank Foodie',
    bio: 'Chef and food enthusiast 🍕🍜',
    password_hash: '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5O3qNq.w6W6gW',
    created_at: localdatetime()
});

CREATE (grace:User {
    user_id: 'user-007-grace',
    email: 'grace@example.com',
    username: 'grace_gamer',
    full_name: 'Grace Gamer',
    bio: 'Pro gamer | Streamer | Cat lover 🎮🐱',
    password_hash: '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5O3qNq.w6W6gW',
    created_at: localdatetime()
});

CREATE (henry:User {
    user_id: 'user-008-henry',
    email: 'henry@example.com',
    username: 'henry_health',
    full_name: 'Henry Health',
    bio: 'Fitness coach helping you reach your goals 💪',
    password_hash: '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5O3qNq.w6W6gW',
    created_at: localdatetime()
});

CREATE (iris:User {
    user_id: 'user-009-iris',
    email: 'iris@example.com',
    username: 'iris_inspire',
    full_name: 'Iris Inspire',
    bio: 'Motivational speaker | Author | Life coach 🌟',
    password_hash: '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5O3qNq.w6W6gW',
    created_at: localdatetime()
});

CREATE (jack:User {
    user_id: 'user-010-jack',
    email: 'jack@example.com',
    username: 'jack_jazz',
    full_name: 'Jack Jazz',
    bio: 'Musician | Producer | Music is life 🎵🎹',
    password_hash: '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5O3qNq.w6W6gW',
    created_at: localdatetime()
});

// Verify users created
MATCH (u:User)
RETURN u.username, u.full_name, u.email
ORDER BY u.created_at;


// ============================================================================
// SECTION 4: CREATE FOLLOW RELATIONSHIPS (Social Graph)
// ============================================================================

// Create a realistic social network where users follow each other
// This creates the foundation for feed generation and friend suggestions

// Alice follows Bob, Carol, David, Emma
MATCH (alice:User {username: 'alice_wonder'})
MATCH (bob:User {username: 'bob_builder'})
CREATE (alice)-[:FOLLOWS {created_at: localdatetime()}]->(bob);

MATCH (alice:User {username: 'alice_wonder'})
MATCH (carol:User {username: 'carol_creative'})
CREATE (alice)-[:FOLLOWS {created_at: localdatetime()}]->(carol);

MATCH (alice:User {username: 'alice_wonder'})
MATCH (david:User {username: 'david_data'})
CREATE (alice)-[:FOLLOWS {created_at: localdatetime()}]->(david);

MATCH (alice:User {username: 'alice_wonder'})
MATCH (emma:User {username: 'emma_explore'})
CREATE (alice)-[:FOLLOWS {created_at: localdatetime()}]->(emma);

// Bob follows Alice, Carol, Frank, Grace
MATCH (bob:User {username: 'bob_builder'})
MATCH (alice:User {username: 'alice_wonder'})
CREATE (bob)-[:FOLLOWS {created_at: localdatetime()}]->(alice);

MATCH (bob:User {username: 'bob_builder'})
MATCH (carol:User {username: 'carol_creative'})
CREATE (bob)-[:FOLLOWS {created_at: localdatetime()}]->(carol);

MATCH (bob:User {username: 'bob_builder'})
MATCH (frank:User {username: 'frank_foodie'})
CREATE (bob)-[:FOLLOWS {created_at: localdatetime()}]->(frank);

MATCH (bob:User {username: 'bob_builder'})
MATCH (grace:User {username: 'grace_gamer'})
CREATE (bob)-[:FOLLOWS {created_at: localdatetime()}]->(grace);

// Carol follows Alice, Bob, Emma, Frank, Iris
MATCH (carol:User {username: 'carol_creative'})
MATCH (alice:User {username: 'alice_wonder'})
CREATE (carol)-[:FOLLOWS {created_at: localdatetime()}]->(alice);

MATCH (carol:User {username: 'carol_creative'})
MATCH (bob:User {username: 'bob_builder'})
CREATE (carol)-[:FOLLOWS {created_at: localdatetime()}]->(bob);

MATCH (carol:User {username: 'carol_creative'})
MATCH (emma:User {username: 'emma_explore'})
CREATE (carol)-[:FOLLOWS {created_at: localdatetime()}]->(emma);

MATCH (carol:User {username: 'carol_creative'})
MATCH (frank:User {username: 'frank_foodie'})
CREATE (carol)-[:FOLLOWS {created_at: localdatetime()}]->(frank);

MATCH (carol:User {username: 'carol_creative'})
MATCH (iris:User {username: 'iris_inspire'})
CREATE (carol)-[:FOLLOWS {created_at: localdatetime()}]->(iris);

// David follows Alice, Henry, Jack
MATCH (david:User {username: 'david_data'})
MATCH (alice:User {username: 'alice_wonder'})
CREATE (david)-[:FOLLOWS {created_at: localdatetime()}]->(alice);

MATCH (david:User {username: 'david_data'})
MATCH (henry:User {username: 'henry_health'})
CREATE (david)-[:FOLLOWS {created_at: localdatetime()}]->(henry);

MATCH (david:User {username: 'david_data'})
MATCH (jack:User {username: 'jack_jazz'})
CREATE (david)-[:FOLLOWS {created_at: localdatetime()}]->(jack);

// Emma follows Alice, Carol, Frank, Grace, Iris
MATCH (emma:User {username: 'emma_explore'})
MATCH (alice:User {username: 'alice_wonder'})
CREATE (emma)-[:FOLLOWS {created_at: localdatetime()}]->(alice);

MATCH (emma:User {username: 'emma_explore'})
MATCH (carol:User {username: 'carol_creative'})
CREATE (emma)-[:FOLLOWS {created_at: localdatetime()}]->(carol);

MATCH (emma:User {username: 'emma_explore'})
MATCH (frank:User {username: 'frank_foodie'})
CREATE (emma)-[:FOLLOWS {created_at: localdatetime()}]->(frank);

MATCH (emma:User {username: 'emma_explore'})
MATCH (grace:User {username: 'grace_gamer'})
CREATE (emma)-[:FOLLOWS {created_at: localdatetime()}]->(grace);

MATCH (emma:User {username: 'emma_explore'})
MATCH (iris:User {username: 'iris_inspire'})
CREATE (emma)-[:FOLLOWS {created_at: localdatetime()}]->(iris);

// Frank follows Bob, Carol, Emma, Henry
MATCH (frank:User {username: 'frank_foodie'})
MATCH (bob:User {username: 'bob_builder'})
CREATE (frank)-[:FOLLOWS {created_at: localdatetime()}]->(bob);

MATCH (frank:User {username: 'frank_foodie'})
MATCH (carol:User {username: 'carol_creative'})
CREATE (frank)-[:FOLLOWS {created_at: localdatetime()}]->(carol);

MATCH (frank:User {username: 'frank_foodie'})
MATCH (emma:User {username: 'emma_explore'})
CREATE (frank)-[:FOLLOWS {created_at: localdatetime()}]->(emma);

MATCH (frank:User {username: 'frank_foodie'})
MATCH (henry:User {username: 'henry_health'})
CREATE (frank)-[:FOLLOWS {created_at: localdatetime()}]->(henry);

// Grace follows Bob, Emma, Jack
MATCH (grace:User {username: 'grace_gamer'})
MATCH (bob:User {username: 'bob_builder'})
CREATE (grace)-[:FOLLOWS {created_at: localdatetime()}]->(bob);

MATCH (grace:User {username: 'grace_gamer'})
MATCH (emma:User {username: 'emma_explore'})
CREATE (grace)-[:FOLLOWS {created_at: localdatetime()}]->(emma);

MATCH (grace:User {username: 'grace_gamer'})
MATCH (jack:User {username: 'jack_jazz'})
CREATE (grace)-[:FOLLOWS {created_at: localdatetime()}]->(jack);

// Henry follows David, Frank, Iris
MATCH (henry:User {username: 'henry_health'})
MATCH (david:User {username: 'david_data'})
CREATE (henry)-[:FOLLOWS {created_at: localdatetime()}]->(david);

MATCH (henry:User {username: 'henry_health'})
MATCH (frank:User {username: 'frank_foodie'})
CREATE (henry)-[:FOLLOWS {created_at: localdatetime()}]->(frank);

MATCH (henry:User {username: 'henry_health'})
MATCH (iris:User {username: 'iris_inspire'})
CREATE (henry)-[:FOLLOWS {created_at: localdatetime()}]->(iris);

// Iris follows Carol, Emma, Henry, Jack
MATCH (iris:User {username: 'iris_inspire'})
MATCH (carol:User {username: 'carol_creative'})
CREATE (iris)-[:FOLLOWS {created_at: localdatetime()}]->(carol);

MATCH (iris:User {username: 'iris_inspire'})
MATCH (emma:User {username: 'emma_explore'})
CREATE (iris)-[:FOLLOWS {created_at: localdatetime()}]->(emma);

MATCH (iris:User {username: 'iris_inspire'})
MATCH (henry:User {username: 'henry_health'})
CREATE (iris)-[:FOLLOWS {created_at: localdatetime()}]->(henry);

MATCH (iris:User {username: 'iris_inspire'})
MATCH (jack:User {username: 'jack_jazz'})
CREATE (iris)-[:FOLLOWS {created_at: localdatetime()}]->(jack);

// Jack follows David, Grace, Iris
MATCH (jack:User {username: 'jack_jazz'})
MATCH (david:User {username: 'david_data'})
CREATE (jack)-[:FOLLOWS {created_at: localdatetime()}]->(david);

MATCH (jack:User {username: 'jack_jazz'})
MATCH (grace:User {username: 'grace_gamer'})
CREATE (jack)-[:FOLLOWS {created_at: localdatetime()}]->(grace);

MATCH (jack:User {username: 'jack_jazz'})
MATCH (iris:User {username: 'iris_inspire'})
CREATE (jack)-[:FOLLOWS {created_at: localdatetime()}]->(iris);

// Verify follow relationships
MATCH (follower:User)-[r:FOLLOWS]->(following:User)
RETURN follower.username AS follower, following.username AS following
ORDER BY r.created_at
LIMIT 20;

// Check follower counts for each user
MATCH (u:User)
OPTIONAL MATCH (follower:User)-[:FOLLOWS]->(u)
WITH u, COUNT(follower) AS follower_count
OPTIONAL MATCH (u)-[:FOLLOWS]->(following:User)
RETURN u.username, follower_count, COUNT(following) AS following_count
ORDER BY follower_count DESC;


// ============================================================================
// SECTION 5: CREATE POSTS
// ============================================================================

// Create posts from various users with realistic content

// Alice's posts
MATCH (alice:User {username: 'alice_wonder'})
CREATE (p1:Post {
    post_id: 'post-001',
    content: 'Just finished debugging the nastiest bug I have ever seen. Took 3 hours but finally found it was a missing semicolon 😅 #DevLife',
    image_url: null,
    created_at: localdatetime()
})
CREATE (alice)-[:POSTED {created_at: localdatetime()}]->(p1);

MATCH (alice:User {username: 'alice_wonder'})
CREATE (p2:Post {
    post_id: 'post-002',
    content: 'Morning coffee and coding is the perfect combination ☕💻 What is your morning routine?',
    image_url: 'https://images.unsplash.com/photo-1509042239860-f550ce710b93',
    created_at: localdatetime()
})
CREATE (alice)-[:POSTED {created_at: localdatetime()}]->(p2);

// Bob's posts
MATCH (bob:User {username: 'bob_builder'})
CREATE (p3:Post {
    post_id: 'post-003',
    content: 'Excited to announce my new project! Building a tool to help developers automate their workflows. Beta testing starts next week! 🚀',
    image_url: null,
    created_at: localdatetime()
})
CREATE (bob)-[:POSTED {created_at: localdatetime()}]->(p3);

MATCH (bob:User {username: 'bob_builder'})
CREATE (p4:Post {
    post_id: 'post-004',
    content: 'Pro tip: Always write tests before you write code. Future you will thank present you! #TDD',
    image_url: null,
    created_at: localdatetime()
})
CREATE (bob)-[:POSTED {created_at: localdatetime()}]->(p4);

// Carol's posts
MATCH (carol:User {username: 'carol_creative'})
CREATE (p5:Post {
    post_id: 'post-005',
    content: 'Finished this digital illustration today! Took me about 8 hours but so worth it 🎨✨',
    image_url: 'https://images.unsplash.com/photo-1513364776144-60967b0f800f',
    created_at: localdatetime()
})
CREATE (carol)-[:POSTED {created_at: localdatetime()}]->(p5);

MATCH (carol:User {username: 'carol_creative'})
CREATE (p6:Post {
    post_id: 'post-006',
    content: 'Design inspiration for today: sometimes the best designs are the simplest ones. Less is more!',
    image_url: null,
    created_at: localdatetime()
})
CREATE (carol)-[:POSTED {created_at: localdatetime()}]->(p6);

// David's posts
MATCH (david:User {username: 'david_data'})
CREATE (p7:Post {
    post_id: 'post-007',
    content: 'Analyzed 10 million records today and discovered some fascinating patterns in user behavior. Data science is amazing! 📊',
    image_url: null,
    created_at: localdatetime()
})
CREATE (david)-[:POSTED {created_at: localdatetime()}]->(p7);

MATCH (david:User {username: 'david_data'})
CREATE (p8:Post {
    post_id: 'post-008',
    content: 'Who else loves a good data visualization? Check out this chart showing tech trends over the last decade!',
    image_url: 'https://images.unsplash.com/photo-1551288049-bebda4e38f71',
    created_at: localdatetime()
})
CREATE (david)-[:POSTED {created_at: localdatetime()}]->(p8);

// Emma's posts
MATCH (emma:User {username: 'emma_explore'})
CREATE (p9:Post {
    post_id: 'post-009',
    content: 'Just landed in Tokyo! 🇯🇵 First time here and already in love with this city. Any recommendations?',
    image_url: 'https://images.unsplash.com/photo-1540959733332-eab4deabeeaf',
    created_at: localdatetime()
})
CREATE (emma)-[:POSTED {created_at: localdatetime()}]->(p9);

MATCH (emma:User {username: 'emma_explore'})
CREATE (p10:Post {
    post_id: 'post-010',
    content: 'Sunrise at Mount Fuji. No words can describe this moment. 🗻🌅',
    image_url: 'https://images.unsplash.com/photo-1490806843957-31f4c9a91c65',
    created_at: localdatetime()
})
CREATE (emma)-[:POSTED {created_at: localdatetime()}]->(p10);

// Frank's posts
MATCH (frank:User {username: 'frank_foodie'})
CREATE (p11:Post {
    post_id: 'post-011',
    content: 'Made the perfect carbonara today! The key is getting the egg temperature just right. Who wants the recipe? 🍝',
    image_url: 'https://images.unsplash.com/photo-1612874742237-6526221588e3',
    created_at: localdatetime()
})
CREATE (frank)-[:POSTED {created_at: localdatetime()}]->(p11);

MATCH (frank:User {username: 'frank_foodie'})
CREATE (p12:Post {
    post_id: 'post-012',
    content: 'Food is not just about taste, it is about the memories we create around the table ❤️🍽️',
    image_url: null,
    created_at: localdatetime()
})
CREATE (frank)-[:POSTED {created_at: localdatetime()}]->(p12);

// Grace's posts
MATCH (grace:User {username: 'grace_gamer'})
CREATE (p13:Post {
    post_id: 'post-013',
    content: 'FINALLY beat that boss after 47 attempts! The sense of achievement is UNREAL! 🎮🏆 #GamerLife',
    image_url: null,
    created_at: localdatetime()
})
CREATE (grace)-[:POSTED {created_at: localdatetime()}]->(p13);

MATCH (grace:User {username: 'grace_gamer'})
CREATE (p14:Post {
    post_id: 'post-014',
    content: 'Streaming tonight at 8 PM! Come hang out and watch me play the new RPG everyone is talking about! 🎮✨',
    image_url: 'https://images.unsplash.com/photo-1542751371-adc38448a05e',
    created_at: localdatetime()
})
CREATE (grace)-[:POSTED {created_at: localdatetime()}]->(p14);

// Henry's posts
MATCH (henry:User {username: 'henry_health'})
CREATE (p15:Post {
    post_id: 'post-015',
    content: 'Remember: fitness is not about being better than someone else. It is about being better than you used to be 💪',
    image_url: null,
    created_at: localdatetime()
})
CREATE (henry)-[:POSTED {created_at: localdatetime()}]->(p15);

MATCH (henry:User {username: 'henry_health'})
CREATE (p16:Post {
    post_id: 'post-016',
    content: 'Morning workout complete! 100 pushups, 50 pullups, 5km run. How did you start your day?',
    image_url: 'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b',
    created_at: localdatetime()
})
CREATE (henry)-[:POSTED {created_at: localdatetime()}]->(p16);

// Iris's posts
MATCH (iris:User {username: 'iris_inspire'})
CREATE (p17:Post {
    post_id: 'post-017',
    content: 'Your limitation—it is only your imagination. Dream big, work hard, stay focused! 🌟',
    image_url: null,
    created_at: localdatetime()
})
CREATE (iris)-[:POSTED {created_at: localdatetime()}]->(p17);

MATCH (iris:User {username: 'iris_inspire'})
CREATE (p18:Post {
    post_id: 'post-018',
    content: 'Just finished writing chapter 5 of my new book! The words just flowed today. Grateful for the creative energy ✍️📖',
    image_url: null,
    created_at: localdatetime()
})
CREATE (iris)-[:POSTED {created_at: localdatetime()}]->(p18);

// Jack's posts
MATCH (jack:User {username: 'jack_jazz'})
CREATE (p19:Post {
    post_id: 'post-019',
    content: 'Late night jam session turned into a whole new track! Music is pure magic 🎵🎹 Listen link in bio!',
    image_url: 'https://images.unsplash.com/photo-1511379938547-c1f69419868d',
    created_at: localdatetime()
})
CREATE (jack)-[:POSTED {created_at: localdatetime()}]->(p19);

MATCH (jack:User {username: 'jack_jazz'})
CREATE (p20:Post {
    post_id: 'post-020',
    content: 'Collaborating with amazing musicians this week. New album coming soon! Stay tuned 🎶',
    image_url: null,
    created_at: localdatetime()
})
CREATE (jack)-[:POSTED {created_at: localdatetime()}]->(p20);

// Verify posts created
MATCH (u:User)-[:POSTED]->(p:Post)
RETURN u.username AS author, p.post_id, p.content, p.created_at
ORDER BY p.created_at DESC;


// ============================================================================
// SECTION 6: CREATE LIKES
// ============================================================================

// Users like various posts to create engagement

// Alice likes posts
MATCH (alice:User {username: 'alice_wonder'})
MATCH (p:Post {post_id: 'post-003'})
CREATE (alice)-[:LIKES {created_at: localdatetime()}]->(p);

MATCH (alice:User {username: 'alice_wonder'})
MATCH (p:Post {post_id: 'post-005'})
CREATE (alice)-[:LIKES {created_at: localdatetime()}]->(p);

MATCH (alice:User {username: 'alice_wonder'})
MATCH (p:Post {post_id: 'post-007'})
CREATE (alice)-[:LIKES {created_at: localdatetime()}]->(p);

MATCH (alice:User {username: 'alice_wonder'})
MATCH (p:Post {post_id: 'post-009'})
CREATE (alice)-[:LIKES {created_at: localdatetime()}]->(p);

// Bob likes posts
MATCH (bob:User {username: 'bob_builder'})
MATCH (p:Post {post_id: 'post-001'})
CREATE (bob)-[:LIKES {created_at: localdatetime()}]->(p);

MATCH (bob:User {username: 'bob_builder'})
MATCH (p:Post {post_id: 'post-002'})
CREATE (bob)-[:LIKES {created_at: localdatetime()}]->(p);

MATCH (bob:User {username: 'bob_builder'})
MATCH (p:Post {post_id: 'post-005'})
CREATE (bob)-[:LIKES {created_at: localdatetime()}]->(p);

MATCH (bob:User {username: 'bob_builder'})
MATCH (p:Post {post_id: 'post-011'})
CREATE (bob)-[:LIKES {created_at: localdatetime()}]->(p);

MATCH (bob:User {username: 'bob_builder'})
MATCH (p:Post {post_id: 'post-013'})
CREATE (bob)-[:LIKES {created_at: localdatetime()}]->(p);

// Carol likes posts
MATCH (carol:User {username: 'carol_creative'})
MATCH (p:Post {post_id: 'post-001'})
CREATE (carol)-[:LIKES {created_at: localdatetime()}]->(p);

MATCH (carol:User {username: 'carol_creative'})
MATCH (p:Post {post_id: 'post-002'})
CREATE (carol)-[:LIKES {created_at: localdatetime()}]->(p);

MATCH (carol:User {username: 'carol_creative'})
MATCH (p:Post {post_id: 'post-009'})
CREATE (carol)-[:LIKES {created_at: localdatetime()}]->(p);

MATCH (carol:User {username: 'carol_creative'})
MATCH (p:Post {post_id: 'post-011'})
CREATE (carol)-[:LIKES {created_at: localdatetime()}]->(p);

MATCH (carol:User {username: 'carol_creative'})
MATCH (p:Post {post_id: 'post-017'})
CREATE (carol)-[:LIKES {created_at: localdatetime()}]->(p);

// David likes posts
MATCH (david:User {username: 'david_data'})
MATCH (p:Post {post_id: 'post-001'})
CREATE (david)-[:LIKES {created_at: localdatetime()}]->(p);

MATCH (david:User {username: 'david_data'})
MATCH (p:Post {post_id: 'post-019'})
CREATE (david)-[:LIKES {created_at: localdatetime()}]->(p);

// Emma likes posts
MATCH (emma:User {username: 'emma_explore'})
MATCH (p:Post {post_id: 'post-002'})
CREATE (emma)-[:LIKES {created_at: localdatetime()}]->(p);

MATCH (emma:User {username: 'emma_explore'})
MATCH (p:Post {post_id: 'post-005'})
CREATE (emma)-[:LIKES {created_at: localdatetime()}]->(p);

MATCH (emma:User {username: 'emma_explore'})
MATCH (p:Post {post_id: 'post-011'})
CREATE (emma)-[:LIKES {created_at: localdatetime()}]->(p);

MATCH (emma:User {username: 'emma_explore'})
MATCH (p:Post {post_id: 'post-017'})
CREATE (emma)-[:LIKES {created_at: localdatetime()}]->(p);

// Frank likes posts
MATCH (frank:User {username: 'frank_foodie'})
MATCH (p:Post {post_id: 'post-003'})
CREATE (frank)-[:LIKES {created_at: localdatetime()}]->(p);

MATCH (frank:User {username: 'frank_foodie'})
MATCH (p:Post {post_id: 'post-005'})
CREATE (frank)-[:LIKES {created_at: localdatetime()}]->(p);

MATCH (frank:User {username: 'frank_foodie'})
MATCH (p:Post {post_id: 'post-009'})
CREATE (frank)-[:LIKES {created_at: localdatetime()}]->(p);

MATCH (frank:User {username: 'frank_foodie'})
MATCH (p:Post {post_id: 'post-015'})
CREATE (frank)-[:LIKES {created_at: localdatetime()}]->(p);

// Grace likes posts
MATCH (grace:User {username: 'grace_gamer'})
MATCH (p:Post {post_id: 'post-003'})
CREATE (grace)-[:LIKES {created_at: localdatetime()}]->(p);

MATCH (grace:User {username: 'grace_gamer'})
MATCH (p:Post {post_id: 'post-009'})
CREATE (grace)-[:LIKES {created_at: localdatetime()}]->(p);

MATCH (grace:User {username: 'grace_gamer'})
MATCH (p:Post {post_id: 'post-019'})
CREATE (grace)-[:LIKES {created_at: localdatetime()}]->(p);

// Henry likes posts
MATCH (henry:User {username: 'henry_health'})
MATCH (p:Post {post_id: 'post-007'})
CREATE (henry)-[:LIKES {created_at: localdatetime()}]->(p);

MATCH (henry:User {username: 'henry_health'})
MATCH (p:Post {post_id: 'post-011'})
CREATE (henry)-[:LIKES {created_at: localdatetime()}]->(p);

MATCH (henry:User {username: 'henry_health'})
MATCH (p:Post {post_id: 'post-017'})
CREATE (henry)-[:LIKES {created_at: localdatetime()}]->(p);

// Iris likes posts
MATCH (iris:User {username: 'iris_inspire'})
MATCH (p:Post {post_id: 'post-005'})
CREATE (iris)-[:LIKES {created_at: localdatetime()}]->(p);

MATCH (iris:User {username: 'iris_inspire'})
MATCH (p:Post {post_id: 'post-009'})
CREATE (iris)-[:LIKES {created_at: localdatetime()}]->(p);

MATCH (iris:User {username: 'iris_inspire'})
MATCH (p:Post {post_id: 'post-010'})
CREATE (iris)-[:LIKES {created_at: localdatetime()}]->(p);

MATCH (iris:User {username: 'iris_inspire'})
MATCH (p:Post {post_id: 'post-015'})
CREATE (iris)-[:LIKES {created_at: localdatetime()}]->(p);

// Jack likes posts
MATCH (jack:User {username: 'jack_jazz'})
MATCH (p:Post {post_id: 'post-007'})
CREATE (jack)-[:LIKES {created_at: localdatetime()}]->(p);

MATCH (jack:User {username: 'jack_jazz'})
MATCH (p:Post {post_id: 'post-013'})
CREATE (jack)-[:LIKES {created_at: localdatetime()}]->(p);

MATCH (jack:User {username: 'jack_jazz'})
MATCH (p:Post {post_id: 'post-017'})
CREATE (jack)-[:LIKES {created_at: localdatetime()}]->(p);

// Verify likes
MATCH (u:User)-[r:LIKES]->(p:Post)
RETURN u.username AS user, p.post_id AS post
ORDER BY r.created_at
LIMIT 20;

// Check posts with most likes
MATCH (p:Post)<-[r:LIKES]-(u:User)
WITH p, COUNT(r) AS like_count
MATCH (author:User)-[:POSTED]->(p)
RETURN author.username AS author, p.post_id, SUBSTRING(p.content, 0, 50) AS preview, like_count
ORDER BY like_count DESC;


// ============================================================================
// SECTION 7: CREATE COMMENTS
// ============================================================================

// Users comment on various posts

// Comments on Alice's coffee post (post-002)
MATCH (bob:User {username: 'bob_builder'})
MATCH (p:Post {post_id: 'post-002'})
CREATE (c1:Comment {
    comment_id: 'comment-001',
    content: 'I am a tea person myself but I totally get this! ☕',
    created_at: localdatetime()
})
CREATE (bob)-[:COMMENTED]->(c1)
CREATE (c1)-[:COMMENTED_ON]->(p);

MATCH (carol:User {username: 'carol_creative'})
MATCH (p:Post {post_id: 'post-002'})
CREATE (c2:Comment {
    comment_id: 'comment-002',
    content: 'Same! Cannot start my day without coffee. What is your favorite blend?',
    created_at: localdatetime()
})
CREATE (carol)-[:COMMENTED]->(c2)
CREATE (c2)-[:COMMENTED_ON]->(p);

// Comments on Bob's project announcement (post-003)
MATCH (alice:User {username: 'alice_wonder'})
MATCH (p:Post {post_id: 'post-003'})
CREATE (c3:Comment {
    comment_id: 'comment-003',
    content: 'This sounds amazing! Count me in for beta testing! 🚀',
    created_at: localdatetime()
})
CREATE (alice)-[:COMMENTED]->(c3)
CREATE (c3)-[:COMMENTED_ON]->(p);

MATCH (carol:User {username: 'carol_creative'})
MATCH (p:Post {post_id: 'post-003'})
CREATE (c4:Comment {
    comment_id: 'comment-004',
    content: 'Would love to help with the UI design if you need it!',
    created_at: localdatetime()
})
CREATE (carol)-[:COMMENTED]->(c4)
CREATE (c4)-[:COMMENTED_ON]->(p);

MATCH (grace:User {username: 'grace_gamer'})
MATCH (p:Post {post_id: 'post-003'})
CREATE (c5:Comment {
    comment_id: 'comment-005',
    content: 'Looking forward to seeing what you build!',
    created_at: localdatetime()
})
CREATE (grace)-[:COMMENTED]->(c5)
CREATE (c5)-[:COMMENTED_ON]->(p);

// Comments on Carol's art (post-005)
MATCH (alice:User {username: 'alice_wonder'})
MATCH (p:Post {post_id: 'post-005'})
CREATE (c6:Comment {
    comment_id: 'comment-006',
    content: 'This is absolutely stunning! Your art keeps getting better 🎨',
    created_at: localdatetime()
})
CREATE (alice)-[:COMMENTED]->(c6)
CREATE (c6)-[:COMMENTED_ON]->(p);

MATCH (emma:User {username: 'emma_explore'})
MATCH (p:Post {post_id: 'post-005'})
CREATE (c7:Comment {
    comment_id: 'comment-007',
    content: 'The colors are incredible! Do you sell prints?',
    created_at: localdatetime()
})
CREATE (emma)-[:COMMENTED]->(c7)
CREATE (c7)-[:COMMENTED_ON]->(p);

// Comments on Emma's Tokyo post (post-009)
MATCH (carol:User {username: 'carol_creative'})
MATCH (p:Post {post_id: 'post-009'})
CREATE (c8:Comment {
    comment_id: 'comment-008',
    content: 'Tokyo is amazing! Make sure to visit Akihabara!',
    created_at: localdatetime()
})
CREATE (carol)-[:COMMENTED]->(c8)
CREATE (c8)-[:COMMENTED_ON]->(p);

MATCH (frank:User {username: 'frank_foodie'})
MATCH (p:Post {post_id: 'post-009'})
CREATE (c9:Comment {
    comment_id: 'comment-009',
    content: 'You HAVE to try authentic ramen while you are there! Best food ever 🍜',
    created_at: localdatetime()
})
CREATE (frank)-[:COMMENTED]->(c9)
CREATE (c9)-[:COMMENTED_ON]->(p);

MATCH (iris:User {username: 'iris_inspire'})
MATCH (p:Post {post_id: 'post-009'})
CREATE (c10:Comment {
    comment_id: 'comment-010',
    content: 'Safe travels! Take lots of photos!',
    created_at: localdatetime()
})
CREATE (iris)-[:COMMENTED]->(c10)
CREATE (c10)-[:COMMENTED_ON]->(p);

// Comments on Frank's carbonara (post-011)
MATCH (bob:User {username: 'bob_builder'})
MATCH (p:Post {post_id: 'post-011'})
CREATE (c11:Comment {
    comment_id: 'comment-011',
    content: 'YES! Please share the recipe!',
    created_at: localdatetime()
})
CREATE (bob)-[:COMMENTED]->(c11)
CREATE (c11)-[:COMMENTED_ON]->(p);

MATCH (emma:User {username: 'emma_explore'})
MATCH (p:Post {post_id: 'post-011'})
CREATE (c12:Comment {
    comment_id: 'comment-012',
    content: 'This looks incredible! My mouth is watering 🤤',
    created_at: localdatetime()
})
CREATE (emma)-[:COMMENTED]->(c12)
CREATE (c12)-[:COMMENTED_ON]->(p);

MATCH (henry:User {username: 'henry_health'})
MATCH (p:Post {post_id: 'post-011'})
CREATE (c13:Comment {
    comment_id: 'comment-013',
    content: 'Looks delicious! What is the calorie count on this? 😄',
    created_at: localdatetime()
})
CREATE (henry)-[:COMMENTED]->(c13)
CREATE (c13)-[:COMMENTED_ON]->(p);

// Comments on Grace's boss victory (post-013)
MATCH (bob:User {username: 'bob_builder'})
MATCH (p:Post {post_id: 'post-013'})
CREATE (c14:Comment {
    comment_id: 'comment-014',
    content: 'Congrats! That boss is BRUTAL! Well done! 🎉',
    created_at: localdatetime()
})
CREATE (bob)-[:COMMENTED]->(c14)
CREATE (c14)-[:COMMENTED_ON]->(p);

MATCH (jack:User {username: 'jack_jazz'})
MATCH (p:Post {post_id: 'post-013'})
CREATE (c15:Comment {
    comment_id: 'comment-015',
    content: 'Persistence pays off! Great job!',
    created_at: localdatetime()
})
CREATE (jack)-[:COMMENTED]->(c15)
CREATE (c15)-[:COMMENTED_ON]->(p);

// Comments on Iris's motivation post (post-017)
MATCH (carol:User {username: 'carol_creative'})
MATCH (p:Post {post_id: 'post-017'})
CREATE (c16:Comment {
    comment_id: 'comment-016',
    content: 'Needed to hear this today! Thank you! 🙏',
    created_at: localdatetime()
})
CREATE (carol)-[:COMMENTED]->(c16)
CREATE (c16)-[:COMMENTED_ON]->(p);

MATCH (emma:User {username: 'emma_explore'})
MATCH (p:Post {post_id: 'post-017'})
CREATE (c17:Comment {
    comment_id: 'comment-017',
    content: 'So inspiring! Keep sharing these messages!',
    created_at: localdatetime()
})
CREATE (emma)-[:COMMENTED]->(c17)
CREATE (c17)-[:COMMENTED_ON]->(p);

MATCH (henry:User {username: 'henry_health'})
MATCH (p:Post {post_id: 'post-017'})
CREATE (c18:Comment {
    comment_id: 'comment-018',
    content: 'This is the mindset! Love it! 💪',
    created_at: localdatetime()
})
CREATE (henry)-[:COMMENTED]->(c18)
CREATE (c18)-[:COMMENTED_ON]->(p);

// Verify comments
MATCH (u:User)-[:COMMENTED]->(c:Comment)-[:COMMENTED_ON]->(p:Post)
MATCH (author:User)-[:POSTED]->(p)
RETURN u.username AS commenter, 
       c.content AS comment, 
       author.username AS post_author,
       p.post_id AS post_id
ORDER BY c.created_at
LIMIT 15;

// Check posts with most comments
MATCH (p:Post)<-[:COMMENTED_ON]-(c:Comment)
WITH p, COUNT(c) AS comment_count
MATCH (author:User)-[:POSTED]->(p)
RETURN author.username AS author, 
       p.post_id, 
       SUBSTRING(p.content, 0, 50) AS preview, 
       comment_count
ORDER BY comment_count DESC;


// ============================================================================
// SECTION 8: VERIFICATION QUERIES
// ============================================================================

// Run these to verify your data and see the social graph in action!

// 1. Overall database statistics
MATCH (u:User)
WITH COUNT(u) AS user_count
MATCH (p:Post)
WITH user_count, COUNT(p) AS post_count
MATCH (c:Comment)
WITH user_count, post_count, COUNT(c) AS comment_count
MATCH ()-[r:FOLLOWS]->()
WITH user_count, post_count, comment_count, COUNT(r) AS follow_count
MATCH ()-[r2:LIKES]->()
RETURN user_count, post_count, comment_count, follow_count, COUNT(r2) AS like_count;

// 2. User leaderboard by follower count
MATCH (u:User)
OPTIONAL MATCH (follower:User)-[:FOLLOWS]->(u)
WITH u, COUNT(DISTINCT follower) AS follower_count
OPTIONAL MATCH (u)-[:FOLLOWS]->(following:User)
WITH u, follower_count, COUNT(DISTINCT following) AS following_count
RETURN u.username, u.full_name, follower_count, following_count
ORDER BY follower_count DESC;

// 3. Most popular posts (by likes + comments)
MATCH (author:User)-[:POSTED]->(p:Post)
OPTIONAL MATCH (p)<-[like:LIKES]-()
WITH author, p, COUNT(DISTINCT like) AS like_count
OPTIONAL MATCH (p)<-[:COMMENTED_ON]-(c:Comment)
WITH author, p, like_count, COUNT(DISTINCT c) AS comment_count
RETURN author.username AS author,
       SUBSTRING(p.content, 0, 60) AS post_preview,
       like_count,
       comment_count,
       (like_count + comment_count) AS total_engagement
ORDER BY total_engagement DESC
LIMIT 10;

// 4. Alice's personalized feed (example of feed generation)
MATCH (alice:User {username: 'alice_wonder'})
MATCH (author:User)-[:POSTED]->(p:Post)
WHERE author.user_id = alice.user_id OR (alice)-[:FOLLOWS]->(author)
OPTIONAL MATCH (p)<-[like:LIKES]-()
WITH alice, author, p, COUNT(DISTINCT like) AS like_count
OPTIONAL MATCH (p)<-[:COMMENTED_ON]-(c:Comment)
WITH alice, author, p, like_count, COUNT(DISTINCT c) AS comment_count
OPTIONAL MATCH (alice)-[mylike:LIKES]->(p)
RETURN author.username AS author,
       SUBSTRING(p.content, 0, 60) AS post,
       like_count,
       comment_count,
       mylike IS NOT NULL AS i_liked_this
ORDER BY p.created_at DESC
LIMIT 10;

// 5. Friend suggestions for Alice (friends-of-friends)
MATCH (alice:User {username: 'alice_wonder'})-[:FOLLOWS]->(friend)
MATCH (friend)-[:FOLLOWS]->(suggestion:User)
WHERE suggestion <> alice
  AND NOT (alice)-[:FOLLOWS]->(suggestion)
WITH suggestion, COUNT(DISTINCT friend) AS common_connections
OPTIONAL MATCH (follower:User)-[:FOLLOWS]->(suggestion)
WITH suggestion, common_connections, COUNT(DISTINCT follower) AS follower_count
RETURN suggestion.username AS suggested_user,
       suggestion.full_name AS name,
       common_connections AS mutual_friends,
       follower_count
ORDER BY common_connections DESC, follower_count DESC
LIMIT 5;

// 6. Mutual followers between Alice and Bob
MATCH (mutual:User)-[:FOLLOWS]->(alice:User {username: 'alice_wonder'})
MATCH (mutual)-[:FOLLOWS]->(bob:User {username: 'bob_builder'})
WHERE alice <> bob
RETURN mutual.username AS mutual_follower, mutual.full_name AS name;

// 7. Most active commenters
MATCH (u:User)-[:COMMENTED]->(c:Comment)
WITH u, COUNT(c) AS comment_count
RETURN u.username, u.full_name, comment_count
ORDER BY comment_count DESC
LIMIT 10;

// 8. Visualize the social graph (run this in Neo4j Browser for visual)
MATCH path = (u1:User)-[:FOLLOWS]->(u2:User)
RETURN path
LIMIT 50;


// ============================================================================
// SUCCESS! Your Neo4j social network is now populated with test data!
// ============================================================================
//
// You now have:
// - 10 users with realistic profiles
// - A complex social graph with follow relationships  
// - 20 posts with various content
// - Numerous likes showing engagement
// - Comments creating conversations
//
// Try the verification queries above to explore the data!
// The graph structure makes complex social queries incredibly efficient.
//
// Next steps:
// 1. Run your FastAPI application
// 2. Use the test user credentials (email + "password123") to login
// 3. Test the API endpoints with this populated database
// 4. Explore Neo4j Browser to visualize the relationships
//
// Happy coding! 🚀
// ============================================================================
