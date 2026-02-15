/**
 * PocketBase Collections Setup Script
 * =====================================
 * 
 * Berdasarkan MASTER_ROADMAP.md - Seagma Presence
 * 
 * Collections yang dibuat:
 * 1. users (auth) - User accounts dengan device binding
 * 2. office_locations - Lokasi kantor + geofence + WiFi BSSID
 * 3. attendances - Data absensi dengan audit trail lengkap
 * 4. shifts - Konfigurasi shift kerja
 * 5. leave_requests - Pengajuan izin/cuti/sakit (GANAS module)
 * 
 * API RULES:
 * - Development: LENIENT (untuk testing)
 * - Production: STRICT (ditandai TODO/TECH DEBT)
 * 
 * Run: node setup_pocketbase_collections.js
 */

require('dotenv').config({ path: '../../.env' });

const POCKETBASE_URL = process.env.POCKETBASE_URL;
const PB_ADMIN_EMAIL = process.env.PB_ADMIN_EMAIL;
const PB_ADMIN_PASSWORD = process.env.PB_ADMIN_PASSWORD;

if (!POCKETBASE_URL || !PB_ADMIN_EMAIL || !PB_ADMIN_PASSWORD) {
    console.error('❌ Error: Missing environment variables. Please check .env file.');
    process.exit(1);
}

// ========================================================================
// COLLECTION SCHEMAS
// ========================================================================

/**
 * Users Collection (extends built-in auth)
 * Tambahan fields untuk device binding dan role
 */
const usersSchema = {
    name: "users",
    type: "auth",
    schema: [
        {
            name: "name",
            type: "text",
            required: true,
            options: { min: 2, max: 100 }
        },
        {
            name: "department",
            type: "text",
            required: false,
            options: { max: 100 }
        },
        {
            name: "role",
            type: "select",
            required: true,
            options: {
                values: ["employee", "hr", "admin"],
                maxSelect: 1
            }
        },
        {
            name: "registered_device_id",
            type: "text",
            required: false,
            options: { max: 255 }
        },
        {
            name: "avatar",
            type: "file",
            required: false,
            options: {
                maxSelect: 1,
                maxSize: 2097152, // 2MB
                mimeTypes: ["image/jpeg", "image/png", "image/webp"]
            }
        },
        {
            name: "is_active",
            type: "bool",
            required: false
        },
        {
            name: "last_login_at",
            type: "date",
            required: false
        }
    ],
    // =====================================================================
    // API RULES - DEVELOPMENT MODE (LENIENT)
    // =====================================================================
    // TODO [TECH DEBT - PRODUCTION]: Implementasi rules ketat:
    //   listRule: "@request.auth.role = 'admin' || @request.auth.role = 'hr'"
    //   viewRule: "@request.auth.id = id || @request.auth.role = 'admin'"
    //   createRule: "@request.auth.role = 'admin'"
    //   updateRule: "@request.auth.id = id || @request.auth.role = 'admin'"
    //   deleteRule: "@request.auth.role = 'admin'"
    // =====================================================================
    listRule: "",           // DEV: allow all authenticated
    viewRule: "",           // DEV: allow all authenticated  
    createRule: "",         // DEV: allow all authenticated
    updateRule: "",         // DEV: allow all authenticated
    deleteRule: null,       // STRICT: only admins via API (null = disabled)
    options: {
        allowEmailAuth: true,
        allowUsernameAuth: false,
        minPasswordLength: 8,
        requireEmail: true
    }
};

/**
 * Office Locations Collection
 * Lokasi kantor dengan koordinat GPS, radius, dan WiFi BSSID
 */
const officeLocationsSchema = {
    name: "office_locations",
    type: "base",
    schema: [
        {
            name: "name",
            type: "text",
            required: true,
            options: { min: 2, max: 200 }
        },
        {
            name: "lat",
            type: "number",
            required: true,
            options: { min: -90, max: 90 }
        },
        {
            name: "lng",
            type: "number",
            required: true,
            options: { min: -180, max: 180 }
        },
        {
            name: "radius",
            type: "number",
            required: true,
            options: { min: 10, max: 5000 } // 10m - 5km
        },
        {
            name: "allowed_wifi_bssids",
            type: "json",
            required: false
            // Array of BSSID strings: ["AA:BB:CC:DD:EE:FF", ...]
        },
        {
            name: "address",
            type: "text",
            required: false,
            options: { max: 500 }
        },
        {
            name: "is_active",
            type: "bool",
            required: false
        }
    ],
    // =====================================================================
    // API RULES - DEVELOPMENT MODE (LENIENT)
    // =====================================================================
    // TODO [TECH DEBT - PRODUCTION]: 
    //   listRule: "@request.auth.id != ''"  (authenticated only)
    //   viewRule: "@request.auth.id != ''"
    //   createRule: "@request.auth.role = 'admin'"
    //   updateRule: "@request.auth.role = 'admin'"
    //   deleteRule: "@request.auth.role = 'admin'"
    // =====================================================================
    listRule: "",           // DEV: allow all authenticated
    viewRule: "",           // DEV: allow all authenticated
    createRule: "",         // DEV: allow all (should be admin only)
    updateRule: "",         // DEV: allow all (should be admin only)
    deleteRule: null        // STRICT: disabled
};

/**
 * Attendances Collection
 * Data absensi dengan FULL AUDIT TRAIL sesuai MASTER_ROADMAP
 */
const attendancesSchema = {
    name: "attendances",
    type: "base",
    schema: [
        // Foreign Keys
        {
            name: "user",
            type: "relation",
            required: true,
            options: {
                collectionId: "users",
                cascadeDelete: false,
                maxSelect: 1
            }
        },
        {
            name: "location",
            type: "relation",
            required: false,
            options: {
                collectionId: "office_locations",
                cascadeDelete: false,
                maxSelect: 1
            }
        },
        // Check-in/out times
        {
            name: "check_in_time",
            type: "date",
            required: true
        },
        {
            name: "check_out_time",
            type: "date",
            required: false
        },
        // Location Evidence (AUDIT TRAIL)
        {
            name: "gps_lat",
            type: "number",
            required: false,
            options: { min: -90, max: 90 }
        },
        {
            name: "gps_lng",
            type: "number",
            required: false,
            options: { min: -180, max: 180 }
        },
        {
            name: "gps_accuracy",
            type: "number",
            required: false,
            options: { min: 0, max: 10000 } // meters
        },
        {
            name: "was_mock_location_detected",
            type: "bool",
            required: false
        },
        // WiFi Evidence (AUDIT TRAIL)
        {
            name: "wifi_bssid",
            type: "text",
            required: false,
            options: { max: 50 }
        },
        {
            name: "wifi_ssid",
            type: "text",
            required: false,
            options: { max: 100 }
        },
        {
            name: "is_wifi_verified",
            type: "bool",
            required: false
        },
        // Time Evidence (AUDIT TRAIL)
        {
            name: "trusted_time",
            type: "date",
            required: true
        },
        {
            name: "time_source",
            type: "select",
            required: false,
            options: {
                values: ["ntp", "local", "cached"],
                maxSelect: 1
            }
        },
        {
            name: "time_deviation_seconds",
            type: "number",
            required: false
        },
        // Device Evidence (AUDIT TRAIL)
        {
            name: "device_id",
            type: "text",
            required: true,
            options: { max: 255 }
        },
        {
            name: "device_fingerprint",
            type: "text",
            required: false,
            options: { max: 500 }
        },
        // Sync Evidence (AUDIT TRAIL)
        {
            name: "is_offline_entry",
            type: "bool",
            required: false
        },
        {
            name: "synced_at",
            type: "date",
            required: false
        },
        {
            name: "sync_retry_count",
            type: "number",
            required: false,
            options: { min: 0 }
        },
        // Status & Late handling
        {
            name: "status",
            type: "select",
            required: true,
            options: {
                values: ["present", "late", "absent", "leave", "half_day"],
                maxSelect: 1
            }
        },
        {
            name: "late_reason",
            type: "text",
            required: false,
            options: { max: 500 }
        },
        {
            name: "late_minutes",
            type: "number",
            required: false,
            options: { min: 0 }
        },
        // Photo capture
        {
            name: "photo",
            type: "file",
            required: false,
            options: {
                maxSelect: 1,
                maxSize: 524288, // 500KB (sesuai ROADMAP)
                mimeTypes: ["image/jpeg", "image/png", "image/webp"]
            }
        },
        // Overtime
        {
            name: "overtime_minutes",
            type: "number",
            required: false,
            options: { min: 0 }
        },
        {
            name: "overtime_status",
            type: "select",
            required: false,
            options: {
                values: ["pending", "approved", "rejected"],
                maxSelect: 1
            }
        },
        // Notes
        {
            name: "notes",
            type: "text",
            required: false,
            options: { max: 1000 }
        }
    ],
    // =====================================================================
    // API RULES - DEVELOPMENT MODE (LENIENT)
    // =====================================================================
    // TODO [TECH DEBT - PRODUCTION]: Implementasi rules ketat:
    //   listRule: "@request.auth.id = user || @request.auth.role = 'admin' || @request.auth.role = 'hr'"
    //   viewRule: "@request.auth.id = user || @request.auth.role = 'admin' || @request.auth.role = 'hr'"
    //   createRule: "@request.auth.id != '' && @request.data.user = @request.auth.id"
    //   updateRule: "@request.auth.role = 'admin' || (@request.auth.id = user && check_out_time = null)"
    //   deleteRule: null (never delete attendance records)
    // 
    // SECURITY NOTE: Dalam production, user hanya boleh create attendance untuk diri sendiri
    // dan tidak bisa mengubah check_in_time setelah dibuat (immutable audit trail)
    // =====================================================================
    listRule: "",           // DEV: allow all authenticated
    viewRule: "",           // DEV: allow all authenticated
    createRule: "",         // DEV: allow all (should be self-only)
    updateRule: "",         // DEV: allow all (should be restricted)
    deleteRule: null        // STRICT: NEVER delete attendance (audit trail)
};

/**
 * Shifts Collection
 * Konfigurasi shift kerja
 */
const shiftsSchema = {
    name: "shifts",
    type: "base",
    schema: [
        {
            name: "name",
            type: "text",
            required: true,
            options: { min: 2, max: 100 }
        },
        {
            name: "start_time",
            type: "text", // Format: "HH:mm"
            required: true,
            options: { pattern: "^([01]?[0-9]|2[0-3]):[0-5][0-9]$" }
        },
        {
            name: "end_time",
            type: "text", // Format: "HH:mm"
            required: true,
            options: { pattern: "^([01]?[0-9]|2[0-3]):[0-5][0-9]$" }
        },
        {
            name: "grace_period_minutes",
            type: "number",
            required: false,
            options: { min: 0, max: 60 }
        },
        {
            name: "work_days",
            type: "json",
            required: false
            // Array: [1,2,3,4,5] = Mon-Fri
        },
        {
            name: "is_default",
            type: "bool",
            required: false
        },
        {
            name: "is_active",
            type: "bool",
            required: false
        }
    ],
    // =====================================================================
    // API RULES - DEVELOPMENT MODE
    // =====================================================================
    // TODO [TECH DEBT - PRODUCTION]:
    //   listRule: "@request.auth.id != ''"
    //   viewRule: "@request.auth.id != ''"
    //   createRule: "@request.auth.role = 'admin'"
    //   updateRule: "@request.auth.role = 'admin'"
    //   deleteRule: "@request.auth.role = 'admin'"
    // =====================================================================
    listRule: "",
    viewRule: "",
    createRule: "",
    updateRule: "",
    deleteRule: null
};

/**
 * Leave Requests Collection (GANAS Module - Week 3)
 * Pengajuan izin, sakit, cuti
 */
const leaveRequestsSchema = {
    name: "leave_requests",
    type: "base",
    schema: [
        {
            name: "user",
            type: "relation",
            required: true,
            options: {
                collectionId: "users",
                cascadeDelete: false,
                maxSelect: 1
            }
        },
        {
            name: "type",
            type: "select",
            required: true,
            options: {
                values: ["izin", "sakit", "cuti", "dinas_luar"],
                maxSelect: 1
            }
        },
        {
            name: "start_date",
            type: "date",
            required: true
        },
        {
            name: "end_date",
            type: "date",
            required: true
        },
        {
            name: "reason",
            type: "text",
            required: true,
            options: { min: 10, max: 1000 }
        },
        {
            name: "supporting_document",
            type: "file",
            required: false,
            options: {
                maxSelect: 3,
                maxSize: 5242880, // 5MB
                mimeTypes: ["image/jpeg", "image/png", "application/pdf"]
            }
        },
        {
            name: "status",
            type: "select",
            required: true,
            options: {
                values: ["pending", "approved", "rejected"],
                maxSelect: 1
            }
        },
        {
            name: "approved_by",
            type: "relation",
            required: false,
            options: {
                collectionId: "users",
                cascadeDelete: false,
                maxSelect: 1
            }
        },
        {
            name: "approved_at",
            type: "date",
            required: false
        },
        {
            name: "rejection_reason",
            type: "text",
            required: false,
            options: { max: 500 }
        }
    ],
    // =====================================================================
    // API RULES - DEVELOPMENT MODE
    // =====================================================================
    // TODO [TECH DEBT - PRODUCTION]:
    //   listRule: "@request.auth.id = user || @request.auth.role = 'admin' || @request.auth.role = 'hr'"
    //   viewRule: "@request.auth.id = user || @request.auth.role = 'admin' || @request.auth.role = 'hr'"
    //   createRule: "@request.auth.id != '' && @request.data.user = @request.auth.id"
    //   updateRule: "@request.auth.role = 'admin' || @request.auth.role = 'hr'"
    //   deleteRule: null
    // =====================================================================
    listRule: "",
    viewRule: "",
    createRule: "",
    updateRule: "",
    deleteRule: null
};

// ========================================================================
// SETUP FUNCTIONS
// ========================================================================

async function authenticate() {
    console.log('\n🔐 Authenticating as admin...');
    
    const response = await fetch(`${POCKETBASE_URL}/api/collections/_superusers/auth-with-password`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
            identity: PB_ADMIN_EMAIL,
            password: PB_ADMIN_PASSWORD
        })
    });
    
    if (!response.ok) {
        throw new Error('Authentication failed: ' + await response.text());
    }
    
    const data = await response.json();
    console.log('   ✅ Authenticated successfully');
    return data.token;
}

async function getExistingCollections(token) {
    const response = await fetch(`${POCKETBASE_URL}/api/collections`, {
        headers: { 'Authorization': token }
    });
    
    if (!response.ok) {
        throw new Error('Failed to get collections');
    }
    
    const data = await response.json();
    return data.items || [];
}

async function createOrUpdateCollection(token, schema) {
    const existing = await getExistingCollections(token);
    const existingCol = existing.find(c => c.name === schema.name);
    
    if (existingCol) {
        console.log(`   📝 Updating existing collection: ${schema.name}`);
        
        // For 'users' collection, we need special handling
        if (schema.name === 'users') {
            // Update users collection to add our custom fields
            const updatePayload = {
                schema: schema.schema,
                listRule: schema.listRule,
                viewRule: schema.viewRule,
                createRule: schema.createRule,
                updateRule: schema.updateRule,
                deleteRule: schema.deleteRule
            };
            
            const response = await fetch(`${POCKETBASE_URL}/api/collections/${existingCol.id}`, {
                method: 'PATCH',
                headers: { 
                    'Authorization': token,
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(updatePayload)
            });
            
            if (!response.ok) {
                const error = await response.text();
                console.log(`   ⚠️  Warning updating ${schema.name}: ${error}`);
                return false;
            }
            
            console.log(`   ✅ Updated: ${schema.name}`);
            return true;
        }
        
        // For other collections, update schema and rules
        const response = await fetch(`${POCKETBASE_URL}/api/collections/${existingCol.id}`, {
            method: 'PATCH',
            headers: { 
                'Authorization': token,
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({
                schema: schema.schema,
                listRule: schema.listRule,
                viewRule: schema.viewRule,
                createRule: schema.createRule,
                updateRule: schema.updateRule,
                deleteRule: schema.deleteRule
            })
        });
        
        if (!response.ok) {
            const error = await response.text();
            console.log(`   ⚠️  Warning updating ${schema.name}: ${error}`);
            return false;
        }
        
        console.log(`   ✅ Updated: ${schema.name}`);
        return true;
    }
    
    // Create new collection
    console.log(`   🆕 Creating collection: ${schema.name}`);
    
    const response = await fetch(`${POCKETBASE_URL}/api/collections`, {
        method: 'POST',
        headers: { 
            'Authorization': token,
            'Content-Type': 'application/json'
        },
        body: JSON.stringify(schema)
    });
    
    if (!response.ok) {
        const error = await response.text();
        console.log(`   ❌ Failed to create ${schema.name}: ${error}`);
        return false;
    }
    
    console.log(`   ✅ Created: ${schema.name}`);
    return true;
}

async function main() {
    console.log('═══════════════════════════════════════════════════════════');
    console.log('     SEAGMA PRESENCE - PocketBase Collections Setup');
    console.log('═══════════════════════════════════════════════════════════');
    console.log(`Server: ${POCKETBASE_URL}`);
    
    try {
        // Authenticate
        const token = await authenticate();
        
        // Define collections to create (order matters for relations!)
        const collections = [
            usersSchema,           // 1. Users first (auth collection)
            officeLocationsSchema, // 2. Locations (referenced by attendances)
            shiftsSchema,          // 3. Shifts
            attendancesSchema,     // 4. Attendances (references users & locations)
            leaveRequestsSchema    // 5. Leave requests (references users)
        ];
        
        console.log('\n📦 Setting up collections...\n');
        
        const results = {
            success: [],
            failed: []
        };
        
        for (const schema of collections) {
            const success = await createOrUpdateCollection(token, schema);
            if (success) {
                results.success.push(schema.name);
            } else {
                results.failed.push(schema.name);
            }
        }
        
        // Summary
        console.log('\n═══════════════════════════════════════════════════════════');
        console.log('                      SETUP SUMMARY');
        console.log('═══════════════════════════════════════════════════════════');
        console.log(`   ✅ Successful: ${results.success.length}`);
        results.success.forEach(n => console.log(`      - ${n}`));
        
        if (results.failed.length > 0) {
            console.log(`   ❌ Failed: ${results.failed.length}`);
            results.failed.forEach(n => console.log(`      - ${n}`));
        }
        
        console.log('\n═══════════════════════════════════════════════════════════');
        console.log('                    TECH DEBT / TODO');
        console.log('═══════════════════════════════════════════════════════════');
        console.log('   ⚠️  API Rules saat ini: DEVELOPMENT MODE (lenient)');
        console.log('   ');
        console.log('   Sebelum PRODUCTION, update rules di PocketBase Admin:');
        console.log('   ');
        console.log('   1. users collection:');
        console.log('      - listRule: @request.auth.role = "admin" || @request.auth.role = "hr"');
        console.log('      - updateRule: @request.auth.id = id || @request.auth.role = "admin"');
        console.log('   ');
        console.log('   2. attendances collection:');
        console.log('      - createRule: @request.auth.id != "" && @request.data.user = @request.auth.id');
        console.log('      - listRule: @request.auth.id = user || @request.auth.role ~ "admin|hr"');
        console.log('   ');
        console.log('   3. leave_requests collection:');
        console.log('      - createRule: @request.data.user = @request.auth.id');
        console.log('      - updateRule: @request.auth.role ~ "admin|hr"');
        console.log('   ');
        console.log('   Lihat komentar di script ini untuk detail lengkap.');
        console.log('═══════════════════════════════════════════════════════════\n');
        
    } catch (error) {
        console.error('\n❌ Setup failed:', error.message);
        process.exit(1);
    }
}

main();
