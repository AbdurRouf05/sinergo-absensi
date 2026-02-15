/**
 * PocketBase Connection Test Script
 * 
 * Tests connectivity to PocketBase server and S3 endpoint
 * Run: node test_pocketbase.js
 */

require('dotenv').config({ path: '../../.env' });

const POCKETBASE_URL = process.env.POCKETBASE_URL;
const PB_ADMIN_EMAIL = process.env.PB_ADMIN_EMAIL;
const PB_ADMIN_PASSWORD = process.env.PB_ADMIN_PASSWORD;

const S3_ENDPOINT = process.env.S3_ENDPOINT;

if (!POCKETBASE_URL || !PB_ADMIN_EMAIL || !PB_ADMIN_PASSWORD) {
    console.error('❌ Error: Missing environment variables. Please check .env file.');
    process.exit(1);
}

async function testPocketBaseHealth() {
    console.log('\n🔍 Testing PocketBase Health...');
    console.log(`   URL: ${POCKETBASE_URL}/api/health`);
    
    try {
        const response = await fetch(`${POCKETBASE_URL}/api/health`);
        const data = await response.json();
        console.log('   ✅ PocketBase Health:', data);
        return true;
    } catch (error) {
        console.log('   ❌ Health Check Failed:', error.message);
        return false;
    }
}

async function testAdminAuth() {
    console.log('\n🔐 Testing Admin Authentication...');
    console.log(`   Email: ${PB_ADMIN_EMAIL}`);
    
    // Try multiple endpoints (PocketBase versions differ)
    const endpoints = [
        '/api/admins/auth-with-password',      // older PB
        '/api/collections/_superusers/auth-with-password', // PB 0.23+
        '/api/collections/users/auth-with-password'  // regular users collection
    ];
    
    for (const endpoint of endpoints) {
        console.log(`   Trying: ${endpoint}`);
        try {
            const response = await fetch(`${POCKETBASE_URL}${endpoint}`, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({
                    identity: PB_ADMIN_EMAIL,
                    password: PB_ADMIN_PASSWORD
                })
            });
            
            if (response.ok) {
                const data = await response.json();
                console.log('   ✅ Auth Success via', endpoint);
                console.log(`   Token (first 30 chars): ${data.token?.substring(0, 30)}...`);
                return data.token;
            } else {
                const error = await response.json();
                console.log(`   ⚠️  ${endpoint}: ${error.message || response.status}`);
            }
        } catch (error) {
            console.log(`   ⚠️  ${endpoint}: ${error.message}`);
        }
    }
    
    console.log('   ❌ All auth endpoints failed');
    return null;
}

async function listCollections(token) {
    console.log('\n📦 Listing Collections...');
    
    try {
        const response = await fetch(`${POCKETBASE_URL}/api/collections`, {
            headers: token ? { 'Authorization': token } : {}
        });
        
        if (response.ok) {
            const data = await response.json();
            console.log('   ✅ Collections found:', data.items?.length || 0);
            data.items?.forEach(col => {
                console.log(`      - ${col.name} (${col.type})`);
            });
            return data.items;
        } else {
            const error = await response.json();
            console.log('   ⚠️  Could not list collections:', error.message);
            return [];
        }
    } catch (error) {
        console.log('   ❌ Error:', error.message);
        return [];
    }
}

async function checkPocketBaseSettings() {
    console.log('\n⚙️  Checking PocketBase Settings...');
    
    try {
        // Check if admin UI is accessible
        const response = await fetch(`${POCKETBASE_URL}/_/`);
        console.log(`   Admin UI Status: ${response.status}`);
        if (response.status === 200) {
            console.log('   ✅ Admin Panel accessible at', `${POCKETBASE_URL}/_/`);
        }
    } catch (error) {
        console.log('   ⚠️  Could not check admin panel');
    }
}

async function testS3Endpoint() {
    console.log('\n☁️  Testing S3/MinIO Endpoint...');
    console.log(`   URL: ${S3_ENDPOINT}`);
    
    try {
        const response = await fetch(S3_ENDPOINT, { method: 'HEAD' });
        console.log(`   Status: ${response.status} ${response.statusText}`);
        if (response.status < 500) {
            console.log('   ✅ S3 Endpoint is reachable');
            return true;
        } else {
            console.log('   ⚠️  S3 Endpoint returned server error');
            return false;
        }
    } catch (error) {
        console.log('   ❌ S3 Connection Failed:', error.message);
        return false;
    }
}

async function main() {
    console.log('═══════════════════════════════════════════════════════════');
    console.log('        SEAGMA PRESENCE - Connection Test Suite');
    console.log('═══════════════════════════════════════════════════════════');
    
    const results = {
        pocketbase: false,
        auth: false,
        collections: false,
        s3: false
    };
    
    // Test 1: PocketBase Health
    results.pocketbase = await testPocketBaseHealth();
    
    // Check settings
    await checkPocketBaseSettings();
    
    // Test 2: Admin Authentication
    if (results.pocketbase) {
        const token = await testAdminAuth();
        results.auth = !!token;
        
        // Test 3: List Collections (try without auth first)
        console.log('\n📦 Trying to list collections (public access)...');
        const collections = await listCollections(token);
        results.collections = collections.length > 0;
    }
    
    // Test 4: S3 Endpoint
    results.s3 = await testS3Endpoint();
    
    // Summary
    console.log('\n═══════════════════════════════════════════════════════════');
    console.log('                      TEST SUMMARY');
    console.log('═══════════════════════════════════════════════════════════');
    console.log(`   PocketBase Health:     ${results.pocketbase ? '✅ PASS' : '❌ FAIL'}`);
    console.log(`   Admin Authentication:  ${results.auth ? '✅ PASS' : '⚠️  CHECK CREDENTIALS'}`);
    console.log(`   Collections Available: ${results.collections ? '✅ PASS' : '⚠️  NONE YET'}`);
    console.log(`   S3 Endpoint:           ${results.s3 ? '✅ PASS' : '❌ FAIL'}`);
    console.log('═══════════════════════════════════════════════════════════');
    
    if (!results.auth) {
        console.log('\n📝 Note: Admin auth failed. Please check:');
        console.log('   1. Login to Admin UI:', `${POCKETBASE_URL}/_/`);
        console.log('   2. Verify email/password is correct');
        console.log('   3. For PB 0.23+, admin is now in _superusers collection');
    }
    
    console.log('');
}

main();
