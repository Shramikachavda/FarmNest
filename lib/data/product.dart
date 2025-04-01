import 'package:agri_flutter/models/product.dart';

class ProductData {
  static final List<Product> products = [
    // 🌾 FERTILIZERS (10 items)
    Product(
      id: '1',
      name: 'Organic Compost (5kg)',
      category: 'Fertilizer',
      price: 250,
      imageUrl: 'https://m.media-amazon.com/images/I/612JPcKSEPL.jpg',
      description:
          'Enhance your soil’s fertility with this natural organic compost, packed with essential nutrients. Perfect for all types of crops, it improves soil structure, promotes microbial activity, and boosts plant growth. Ideal for organic farming and sustainable agriculture practices. Safe for the environment and easy to use.',
    ),
    Product(
      id: '2',
      name: 'NPK Fertilizer (10kg)',
      category: 'Fertilizer',
      price: 600,
      imageUrl:
          'https://encrypted-tbn0.gstatic.com/shopping?q=tbn:ANd9GcTk2_DQgVf3A7uGGdVoVEbJC8Vbas12ofiKDZR8ViKe6U1HkM0SHd_xU2NXFhpPdf3B78-iaRctORcik3fhCwVZWOzQXHEP3wqNvGwjm3pLCKccJxGRg0Aq6w',
      description:
          'A balanced blend of Nitrogen, Phosphorus, and Potassium (NPK) to ensure optimal plant nutrition. Promotes healthy root development, vigorous growth, and higher crop yields. Suitable for a wide range of crops, including vegetables, fruits, and grains. Easy to apply and highly effective for both small and large-scale farming.',
    ),
    Product(
      id: '3',
      name: 'Vermicompost (2kg)',
      category: 'Fertilizer',
      price: 150,
      imageUrl:
          'https://rukminim2.flixcart.com/image/1200/1200/xif0q/soil-manure/9/a/x/2-vermicompost-2-kg-1-royalgreen-original-imah4u52ne7zasnp.jpeg',
      description:
          'Produced from earthworms, this eco-friendly vermicompost is rich in organic matter and nutrients. Improves soil texture, enhances water retention, and increases microbial activity. Perfect for organic farming, it ensures healthy plant growth and higher yields. A sustainable choice for environmentally conscious farmers.',
    ),
    Product(
      id: '4',
      name: 'Potash Fertilizer (5kg)',
      category: 'Fertilizer',
      price: 400,
      imageUrl:
          'https://encrypted-tbn3.gstatic.com/shopping?q=tbn:ANd9GcRF-EII3vxAMiPLLz6uMqbf9S3x_lTax9FumsKdhK6GEO2Oe5G0EzJrfPeMkJ7H4xdEV0daORI57QovdgHDS6SOwCgXystLqvXno2Af9V96_UvStIUWeqEO',
      description:
          'Boost your crop’s resistance to drought and diseases with this high-potassium fertilizer. Strengthens plant roots, improves water uptake, and enhances overall plant health. Ideal for fruits, vegetables, and flowering plants. Ensures better quality produce and higher yields.',
    ),
    Product(
      id: '5',
      name: 'Calcium Nitrate (3kg)',
      category: 'Fertilizer',
      price: 320,
      imageUrl:
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ8hpv0DE6b36EKRzUv-B8eI9Q69OhOLnRf0Q&s',
      description:
          'A dual-purpose fertilizer that supplies calcium and nitrogen to plants. Prevents calcium deficiency disorders like blossom-end rot in tomatoes and peppers. Promotes strong cell walls, healthy foliage, and improved fruit quality. Suitable for both soil and foliar application.',
    ),
    Product(
      id: '6',
      name: 'Urea (5kg)',
      category: 'Fertilizer',
      price: 220,
      imageUrl:
          'https://down-id.img.susercontent.com/file/129cae76a29d8a244b8e80686336f6c9',
      description:
          'A highly concentrated nitrogen fertilizer that promotes rapid plant growth and lush green foliage. Ideal for crops requiring high nitrogen levels, such as rice, wheat, and maize. Improves protein content in plants and enhances overall crop yield. Easy to apply and cost-effective.',
    ),
    Product(
      id: '7',
      name: 'Seaweed Extract (1L)',
      category: 'Fertilizer',
      price: 550,
      imageUrl:
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTxbv0TKfiW28X6ceQa8OxtDJe5AwjOuvpheQ&s',
      description:
          'Derived from natural seaweed, this organic fertilizer promotes root development and stress resistance in plants. Rich in micronutrients, amino acids, and growth hormones, it enhances plant vigor and crop quality. Suitable for all crops and can be used as a foliar spray or soil drench.',
    ),
    Product(
      id: '8',
      name: 'Magnesium Sulfate (2kg)',
      category: 'Fertilizer',
      price: 180,
      imageUrl: 'https://m.media-amazon.com/images/I/61gORTv9BDL.jpg',
      description:
          'Corrects magnesium and sulfur deficiencies in plants, ensuring healthy growth and vibrant green leaves. Essential for photosynthesis and enzyme activation. Suitable for a wide range of crops, including fruits, vegetables, and ornamentals. Easy to dissolve and apply.',
    ),
    Product(
      id: '9',
      name: 'Bone Meal (3kg)',
      category: 'Fertilizer',
      price: 350,
      imageUrl: 'https://example.com/bone-meal.jpg',
      description:
          'A natural source of phosphorus and calcium, essential for root development and flowering. Ideal for bulbs, roses, and fruit-bearing plants. Promotes strong root systems and abundant blooms. Slow-release formula ensures long-lasting nutrient supply.',
    ),
    Product(
      id: '10',
      name: 'Slow-Release Fertilizer (4kg)',
      category: 'Fertilizer',
      price: 460,
      imageUrl: 'https://i.ebayimg.com/images/g/R-wAAOSwt8Jd-Zut/s-l1200.jpg',
      description:
          'Provides a steady supply of nutrients over an extended period, reducing the need for frequent applications. Promotes consistent plant growth and reduces nutrient leaching. Suitable for lawns, gardens, and container plants. Ensures healthier plants with minimal effort.',
    ),

    // 🌱 PESTICIDES (10 items)
    Product(
      id: '11',
      name: 'Neem Oil (500ml)',
      category: 'Pesticide',
      price: 300,
      imageUrl: 'https://example.com/neem.jpg',
      description:
          'A natural pesticide derived from neem tree seeds, effective against a wide range of pests and fungal diseases. Safe for beneficial insects and environmentally friendly. Can be used on vegetables, fruits, and ornamental plants. Promotes healthy, pest-free crops.',
    ),
    Product(
      id: '12',
      name: 'Insecticide Spray (1L)',
      category: 'Pesticide',
      price: 400,
      imageUrl: 'https://example.com/insecticide.jpg',
      description:
          'A fast-acting insecticide that protects crops from harmful pests like aphids, caterpillars, and beetles. Easy to apply and provides long-lasting protection. Suitable for a wide range of crops, including vegetables, fruits, and grains. Ensures healthy and pest-free plants.',
    ),
    Product(
      id: '13',
      name: 'Herbicide (2L)',
      category: 'Pesticide',
      price: 500,
      imageUrl: 'https://example.com/herbicide.jpg',
      description:
          'A selective herbicide that effectively controls broadleaf weeds without harming crops. Ideal for use in fields, gardens, and lawns. Ensures clean and weed-free farming areas. Easy to apply and provides visible results within days.',
    ),
    Product(
      id: '14',
      name: 'Fungicide (500ml)',
      category: 'Pesticide',
      price: 280,
      imageUrl: 'https://example.com/fungicide.jpg',
      description:
          'Protects crops from fungal infections like powdery mildew, rust, and blight. Suitable for use on vegetables, fruits, and ornamental plants. Easy to apply and provides long-lasting protection. Ensures healthy and disease-free crops.',
    ),
    Product(
      id: '15',
      name: 'Biopesticide (1L)',
      category: 'Pesticide',
      price: 450,
      imageUrl: 'https://example.com/biopesticide.jpg',
      description:
          'An eco-friendly pesticide made from natural ingredients, safe for humans, animals, and beneficial insects. Controls pests like aphids, mites, and whiteflies. Suitable for organic farming and ensures healthy, chemical-free produce.',
    ),
    Product(
      id: '16',
      name: 'Rodent Repellent (500g)',
      category: 'Pesticide',
      price: 200,
      imageUrl: 'https://example.com/rodent-repellent.jpg',
      description:
          'Keeps rodents away from crops and storage areas without harming them. Made from natural ingredients, it is safe for use around humans and animals. Effective for both indoor and outdoor use. Ensures rodent-free farming and storage.',
    ),
    Product(
      id: '17',
      name: 'Pesticide Dust (1kg)',
      category: 'Pesticide',
      price: 350,
      imageUrl: 'https://example.com/pesticide-dust.jpg',
      description:
          'A dust-based pesticide that provides effective control against pests like ants, cockroaches, and termites. Easy to apply and long-lasting. Suitable for use in fields, gardens, and storage areas. Ensures pest-free crops and surroundings.',
    ),
    Product(
      id: '18',
      name: 'Organic Pesticide Spray (1L)',
      category: 'Pesticide',
      price: 480,
      imageUrl: 'https://example.com/organic-pesticide.jpg',
      description:
          'A chemical-free pesticide made from natural ingredients, safe for organic farming. Controls pests like aphids, mites, and caterpillars. Suitable for vegetables, fruits, and ornamental plants. Promotes healthy and eco-friendly farming.',
    ),
    Product(
      id: '19',
      name: 'Mite Killer (500ml)',
      category: 'Pesticide',
      price: 320,
      imageUrl: 'https://example.com/mite-killer.jpg',
      description:
          'Effectively controls mites on crops, ensuring healthy and pest-free plants. Suitable for use on vegetables, fruits, and ornamental plants. Easy to apply and provides long-lasting protection. Ensures high-quality produce.',
    ),
    Product(
      id: '20',
      name: 'Anti-Fungal Spray (1L)',
      category: 'Pesticide',
      price: 400,
      imageUrl: 'https://example.com/anti-fungal.jpg',
      description:
          'Prevents and treats fungal infections like powdery mildew and rust on crops. Suitable for vegetables, fruits, and ornamental plants. Easy to apply and provides visible results within days. Ensures healthy and disease-free plants.',
    ),

    // 🌾 SEEDS (10 items)
    Product(
      id: '21',
      name: 'Wheat Seeds (500g)',
      category: 'Seeds',
      price: 100,
      imageUrl: 'https://example.com/wheat-seeds.jpg',
      description:
          'High-yield wheat seeds suitable for all types of soil and climates. Ensures healthy growth and abundant harvests. Ideal for both small-scale and large-scale farming. Packed with nutrients for strong and healthy plants.',
    ),
    Product(
      id: '22',
      name: 'Corn Seeds (250g)',
      category: 'Seeds',
      price: 180,
      imageUrl: 'https://example.com/corn-seeds.jpg',
      description:
          'Hybrid corn seeds designed for fast germination and high productivity. Suitable for all soil types and climates. Ensures healthy growth and abundant harvests. Perfect for both home gardens and commercial farming.',
    ),
    Product(
      id: '23',
      name: 'Rice Seeds (1kg)',
      category: 'Seeds',
      price: 220,
      imageUrl: 'https://example.com/rice-seeds.jpg',
      description:
          'Premium rice seeds for high productivity and quality grains. Suitable for both irrigated and rainfed farming. Ensures healthy growth and abundant harvests. Ideal for farmers looking for high-yield varieties.',
    ),
    Product(
      id: '24',
      name: 'Tomato Seeds (100g)',
      category: 'Seeds',
      price: 120,
      imageUrl: 'https://example.com/tomato-seeds.jpg',
      description:
          'High-quality tomato seeds for home gardens and commercial farming. Ensures healthy growth and abundant harvests. Suitable for all soil types and climates. Perfect for fresh and healthy produce.',
    ),
    Product(
      id: '25',
      name: 'Sunflower Seeds (500g)',
      category: 'Seeds',
      price: 150,
      imageUrl: 'https://example.com/sunflower-seeds.jpg',
      description:
          'Sunflower seeds for oil and ornamental purposes. Ensures healthy growth and abundant harvests. Suitable for all soil types and climates. Perfect for both home gardens and commercial farming.',
    ),
    Product(
      id: '26',
      name: 'Potato Seeds (2kg)',
      category: 'Seeds',
      price: 300,
      imageUrl: 'https://example.com/potato-seeds.jpg',
      description:
          'Certified potato seeds for healthy and high-yield crops. Suitable for all soil types and climates. Ensures healthy growth and abundant harvests. Perfect for both home gardens and commercial farming.',
    ),
    Product(
      id: '27',
      name: 'Barley Seeds (500g)',
      category: 'Seeds',
      price: 110,
      imageUrl: 'https://example.com/barley-seeds.jpg',
      description:
          'Barley seeds for animal feed and brewing. Ensures healthy growth and abundant harvests. Suitable for all soil types and climates. Perfect for both small-scale and large-scale farming.',
    ),
    Product(
      id: '28',
      name: 'Soybean Seeds (1kg)',
      category: 'Seeds',
      price: 200,
      imageUrl: 'https://example.com/soybean-seeds.jpg',
      description:
          'High-protein soybean seeds for cultivation. Ensures healthy growth and abundant harvests. Suitable for all soil types and climates. Perfect for both home gardens and commercial farming.',
    ),
    Product(
      id: '29',
      name: 'Cucumber Seeds (100g)',
      category: 'Seeds',
      price: 90,
      imageUrl: 'https://example.com/cucumber-seeds.jpg',
      description:
          'Cucumber seeds for fresh and healthy produce. Ensures healthy growth and abundant harvests. Suitable for all soil types and climates. Perfect for both home gardens and commercial farming.',
    ),
    Product(
      id: '30',
      name: 'Carrot Seeds (50g)',
      category: 'Seeds',
      price: 80,
      imageUrl: 'https://example.com/carrot-seeds.jpg',
      description:
          'Carrot seeds for home and commercial farming. Ensures healthy growth and abundant harvests. Suitable for all soil types and climates. Perfect for fresh and healthy produce.',
    ),

    // 🚜 VEHICLES (5 items)
    Product(
      id: '31',
      name: 'Mini Tractor',
      category: 'Vehicles',
      price: 150000,
      imageUrl: 'https://example.com/tractor.jpg',
      description:
          'A compact and versatile tractor designed for small farms. Equipped with a powerful engine and easy-to-use controls, it is perfect for plowing, tilling, and hauling. Ensures efficient farming operations with minimal effort. Ideal for farmers looking for a reliable and cost-effective solution.',
    ),
    Product(
      id: '32',
      name: 'Crop Harvester',
      category: 'Vehicles',
      price: 450000,
      imageUrl: 'https://example.com/harvester.jpg',
      description:
          'An automatic crop harvester designed for large-scale farming. Efficiently harvests crops like wheat, rice, and corn, saving time and labor. Equipped with advanced technology for precise and damage-free harvesting. Ensures high productivity and reduced post-harvest losses.',
    ),
    Product(
      id: '33',
      name: 'Plowing Machine',
      category: 'Vehicles',
      price: 120000,
      imageUrl: 'https://example.com/plowing-machine.jpg',
      description:
          'A powerful plowing machine designed for efficient soil preparation. Suitable for all types of soil, it ensures deep tillage and proper aeration. Easy to operate and maintain, it is perfect for both small and large farms. Ensures healthy soil for better crop growth.',
    ),
    Product(
      id: '34',
      name: 'Seed Drill',
      category: 'Vehicles',
      price: 80000,
      imageUrl: 'https://example.com/seed-drill.jpg',
      description:
          'A precision seed drill for accurate and efficient seed sowing. Ensures uniform seed placement and optimal spacing for better crop growth. Suitable for a wide range of crops, including wheat, rice, and maize. Perfect for farmers looking to improve productivity and reduce seed wastage.',
    ),
    Product(
      id: '35',
      name: 'Sprayer Vehicle',
      category: 'Vehicles',
      price: 95000,
      imageUrl: 'https://example.com/sprayer-vehicle.jpg',
      description:
          'A vehicle-mounted sprayer designed for large-scale farming. Efficiently applies pesticides, herbicides, and fertilizers to crops. Equipped with a high-capacity tank and adjustable nozzles for precise application. Ensures even coverage and reduced chemical wastage.',
    ),

    // 🌧️ IRRIGATION SUPPLIES (5 items)
    Product(
      id: '36',
      name: 'Drip Irrigation Kit',
      category: 'Irrigation Supplies',
      price: 1500,
      imageUrl: 'https://example.com/drip-kit.jpg',
      description:
          'A complete drip irrigation kit designed for water-saving farming. Ensures precise water delivery to plant roots, reducing water wastage. Suitable for vegetables, fruits, and ornamental plants. Easy to install and maintain, it is perfect for both small and large farms.',
    ),
    Product(
      id: '37',
      name: 'Sprinkler System',
      category: 'Irrigation Supplies',
      price: 2500,
      imageUrl: 'https://example.com/sprinkler.jpg',
      description:
          'An efficient sprinkler system for uniform water distribution. Suitable for lawns, gardens, and large farms. Ensures proper watering and healthy plant growth. Easy to install and operate, it is perfect for farmers looking for a reliable irrigation solution.',
    ),
    Product(
      id: '38',
      name: 'Water Pump (1HP)',
      category: 'Irrigation Supplies',
      price: 8000,
      imageUrl: 'https://example.com/water-pump.jpg',
      description:
          'A high-power water pump designed for efficient irrigation. Suitable for wells, ponds, and rivers, it ensures consistent water supply to crops. Easy to operate and maintain, it is perfect for both small and large farms. Ensures healthy and well-watered plants.',
    ),
    Product(
      id: '39',
      name: 'PVC Pipes (10m)',
      category: 'Irrigation Supplies',
      price: 1200,
      imageUrl: 'https://example.com/pvc-pipes.jpg',
      description:
          'Durable PVC pipes designed for irrigation systems. Resistant to corrosion and UV rays, they ensure long-lasting performance. Suitable for drip and sprinkler irrigation systems. Easy to install and maintain, they are perfect for efficient water delivery.',
    ),
    Product(
      id: '40',
      name: 'Irrigation Timer',
      category: 'Irrigation Supplies',
      price: 600,
      imageUrl: 'https://example.com/irrigation-timer.jpg',
      description:
          'An automated irrigation timer for efficient water management. Allows you to schedule watering times and durations, ensuring optimal water usage. Suitable for drip and sprinkler systems. Easy to install and operate, it is perfect for farmers looking to save time and water.',
    ),

    // 🧺 STORAGE & PACKAGING (5 items)
    Product(
      id: '41',
      name: 'Plastic Crates (Set of 5)',
      category: 'Storage & Packaging',
      price: 500,
      imageUrl: 'https://example.com/crates.jpg',
      description:
          'Durable plastic crates designed for storage and transport. Lightweight yet sturdy, they are perfect for carrying fruits, vegetables, and other farm produce. Stackable design saves space and ensures easy handling. Ideal for both small and large-scale farming operations.',
    ),
    Product(
      id: '42',
      name: 'Grain Sacks (10pcs)',
      category: 'Storage & Packaging',
      price: 300,
      imageUrl: 'https://example.com/grain-sacks.jpg',
      description:
          'Heavy-duty grain sacks for storing and transporting grains like wheat, rice, and maize. Made from high-quality material, they are resistant to tearing and moisture. Ensures safe and secure storage of farm produce. Perfect for both small and large-scale farming.',
    ),
    Product(
      id: '43',
      name: 'Vacuum Sealer',
      category: 'Storage & Packaging',
      price: 1200,
      imageUrl: 'https://example.com/vacuum-sealer.jpg',
      description:
          'A vacuum sealer designed for preserving farm produce. Removes air from packaging to extend the shelf life of fruits, vegetables, and grains. Easy to use and maintain, it is perfect for both home and commercial use. Ensures fresh and high-quality produce.',
    ),
    Product(
      id: '44',
      name: 'Storage Bins (50L)',
      category: 'Storage & Packaging',
      price: 700,
      imageUrl: 'https://example.com/storage-bins.jpg',
      description:
          'Large storage bins for storing farm produce like grains, fruits, and vegetables. Made from durable plastic, they are resistant to moisture and pests. Stackable design saves space and ensures easy handling. Perfect for both small and large-scale farming.',
    ),
    Product(
      id: '45',
      name: 'Packaging Bags (100pcs)',
      category: 'Storage & Packaging',
      price: 400,
      imageUrl: 'https://example.com/packaging-bags.jpg',
      description:
          'Eco-friendly packaging bags for farm products. Made from biodegradable material, they are safe for the environment. Perfect for packaging fruits, vegetables, and grains. Ensures fresh and high-quality produce for customers.',
    ),

    // 🛠️ FARM TOOLS (5 items)
    Product(
      id: '46',
      name: 'Hand Plow',
      category: 'Farm Tools',
      price: 750,
      imageUrl: 'https://example.com/plow.jpg',
      description:
          'A durable hand plow designed for soil preparation. Perfect for small farms and home gardens. Ensures proper aeration and soil loosening for healthy plant growth. Easy to use and maintain, it is a must-have tool for every farmer.',
    ),
    Product(
      id: '47',
      name: 'Sprayer (1L)',
      category: 'Farm Tools',
      price: 300,
      imageUrl: 'https://example.com/sprayer.jpg',
      description:
          'A hand sprayer for applying pesticides, herbicides, and fertilizers. Lightweight and easy to use, it ensures even coverage and reduced chemical wastage. Perfect for small farms and home gardens. Ensures healthy and pest-free plants.',
    ),
    Product(
      id: '48',
      name: 'Pruning Shears',
      category: 'Farm Tools',
      price: 450,
      imageUrl: 'https://example.com/pruning-shears.jpg',
      description:
          'Sharp pruning shears designed for trimming plants and trees. Ensures clean cuts and promotes healthy plant growth. Perfect for maintaining gardens and orchards. Easy to use and maintain, it is a must-have tool for every gardener.',
    ),
    Product(
      id: '49',
      name: 'Garden Hoe',
      category: 'Farm Tools',
      price: 350,
      imageUrl: 'https://example.com/garden-hoe.jpg',
      description:
          'A sturdy garden hoe for weeding and soil cultivation. Perfect for small farms and home gardens. Ensures proper soil aeration and weed control. Easy to use and maintain, it is a must-have tool for every farmer.',
    ),
    Product(
      id: '50',
      name: 'Wheelbarrow',
      category: 'Farm Tools',
      price: 1200,
      imageUrl: 'https://example.com/wheelbarrow.jpg',
      description:
          'A heavy-duty wheelbarrow for transporting farm materials like soil, compost, and produce. Designed for easy maneuverability and heavy loads. Perfect for both small and large farms. Ensures efficient and hassle-free farming operations.',
    ),
  ];
}
