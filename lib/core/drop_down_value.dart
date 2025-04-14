enum GrowthStage {
  seed,         // 🌱 Seeds are sown
 
  seedling,     // 🌿 Small plant begins to grow
  vegetative,   // 🌱 Leaves & stems develop
 
  flowering,    // 🌻 Flowers appear
  fruiting,     // 🍎 Fruits or grains start forming
  maturity,     // 🌾 Fully grown & ready to harvest
  harvesting    // 🚜 Harvesting begins
}

enum PesticideType {
  insecticide,  // 🦟 Kills insects
  herbicide,    // 🌿 Kills weeds
  fungicide,    // 🍄 Prevents fungal diseases
  bactericide,  // 🦠 Kills bacteria
  nematicide,   // 🪱 Kills nematodes (worms)
  rodenticide,  // 🐀 Kills rodents
  acaricide,    // 🕷 Kills mites & ticks
  molluscicide  // 🐌 Kills snails & slugs
}

enum FertilizerType {
  nitrogen,    // 🌱 Supports leafy growth (N)
  phosphorus,  // 🌾 Supports root & flower development (P)
  potassium,   // 🍎 Improves fruit quality & resistance (K)
  organic,     // 🌿 Natural compost & manure
  synthetic,   // 🏭 Chemical fertilizers
  biofertilizer, // 🦠 Microbial-based nutrients
  micronutrient // 🏅 Essential trace minerals (Zn, Fe, etc.)
}
 enum LivestockHealthStatus {
  healthy,         // ✅ No health issues, active & normal
  sick,            // 🤒 Showing signs of illness
  injured,         // 🤕 Physical injury present
  recovering,      // 🔄 Recovering from illness or injury
  underObservation, // 👀 Being monitored for symptoms
  vaccinated,      // 💉 Recently vaccinated
  malnourished,    // 🍽 Suffering from poor nutrition
  deceased         // ❌ Passed away
}
enum Gender {
  male,   // ♂ Male
  female  // ♀ Female
}

enum LivestockAge {
  infant,   // 🍼 0-3 months
  juvenile, // 🧒 3-12 months
  adult,    // 🐂 1-5 years
  senior    // 🧓 5+ years
}

enum Categoty {

    harvesting,
    irrigation,
    pesticideApplication,
    fertilization,
    equipmentMaintenance,
    soilTesting,
    livestockCare,
    marketVisit,
  other,
}

enum FarmOwnershipType {
  individual,
  family,
  partnership,
  corporate,
  leased,
  government,
}

enum FarmersAllocated {
  none,
  one,
  two,
  three,
  four,
  five,
  six
}

enum LivestockPurpose {
  dairy,         // Milk production
  meat,          // Meat production
  breeding,      // Reproduction/genetics
  draft,         // Field work/manual labor
  manure,        // Organic fertilizer
  poultry,       // Eggs and meat
  wool,          // Fiber or wool for sale/use
  multiPurpose;  // Combines multiple farm functions
}
enum LivestockType {
  cow,         // Primary source of milk (Gir, Kankrej breeds common in Gujarat)
  buffalo,     // High milk yield, especially Jaffarabadi & Mehsana breeds
  goat,        // Popular for meat & milk (e.g., Surti breed)
  sheep,       // Wool and meat (used more in dry areas like Saurashtra & Kutch)
  poultry,     // Eggs and meat (layer and broiler farming rising in Gujarat)
  ox,          // Draft purposes (especially in traditional farms)
  donkey,      // Still used in hilly or rural transport in some regions
  pig,         // Reared in some tribal/rural areas for meat
}


