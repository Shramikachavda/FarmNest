// services/gemini_service/crop_advice_service.dart
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:intl/intl.dart';

class GeminiService {
  final String apiKey =
      'AIzaSyDK4TME_6YPTDBvteVSuoyA05cBgRueiYQ'; // Replace with your Gemini API key
  final String modelName = 'gemini-1.5-flash-latest';

  Future<String> getCropRecommendations({
    required String cropName,
    required String growthStage,
    required String sowingDate,
    required String harvestDate,
    required String fertilizer,
    required String pesticide,
    required String temperature,
    required String humidity,
    String? weatherDescription,
    String? location,
  }) async {
    try {
      if (!_validateDates(sowingDate, harvestDate)) {
        return '🚫 Invalid sowing or harvest date. Sowing date cannot be after harvest date, and the duration must be reasonable (at least 30 days).';
      }

      final model = GenerativeModel(model: modelName, apiKey: apiKey);

      final htmlPrompt = '''
You are an expert agricultural advisor. Based on the information below, generate a detailed crop advisory in pure HTML format with embedded CSS for styling. 

Use tags like <h2>, <ul>, <li>, <strong>, <p>, etc. Style the headings, sections, and bullet points. Use emojis where relevant. Do not include any AI disclaimers or intros.

Wrap the HTML content inside a <html><head><style>...</style></head><body>...</body></html> structure.

Include the following CSS:
- h2 with green color and margin
- ul with spacing
- li with padding and emoji styling
- paragraphs with readable font size

<html>
<head>
<style>
  body {
    font-family: Arial, Lato;
   
  }
  h2 {
    color: #c1e7b8;
 
  }

  li {
    margin-bottom: 8px;
  }
  p {
    font-size: 16px;
  }
</style>
</head>
<body>

<h2>🌱 Growth Stage Advisory</h2>
<p>Explain what happens during the <strong>$growthStage</strong> stage for <strong>$cropName</strong>. Mention what care is needed, common risks, and how to mitigate them.</p>

<h2>💧 Irrigation and Nutrient Plan</h2>
<ul>
  <li>Recommended irrigation schedule with frequency and quantity</li>
  <li>Nutrient monitoring tips</li>
  <li>Best practices for fertilizer usage (timing, dosage)</li>
</ul>

<h2>🐛 Pest & Disease Prevention</h2>
<ul>
  <li>Common pests/diseases at this stage</li>
  <li>Early warning signs</li>
  <li>Organic & chemical solutions with dosage and timing</li>
</ul>

<h2>☀️ Climate Impact Analysis</h2>
<p>Discuss how the current weather affects the crop and how to protect it based on temperature ($temperature°C) and humidity ($humidity%).</p>

<h2>🧑‍🌾 Action Plan (Next 2–4 Weeks)</h2>
<ul>
  <li>Key tasks to perform (priority wise)</li>
  <li>⚠️ Mistakes to avoid</li>
  <li>✅ Tips to improve yield</li>
</ul>

</body>
</html>

''';

      final content = [Content.text(htmlPrompt)];
      final response = await model.generateContent(content);

      return response.text ?? '❌ No recommendations received';
    } catch (e) {
      return '❌ Failed to generate recommendations: $e';
    }
  }

  bool _validateDates(String sowingDate, String harvestDate) {
    try {
      final dateFormat = DateFormat('yyyy-MM-dd');
      final sowing = dateFormat.parse(sowingDate);
      final harvest = dateFormat.parse(harvestDate);
      return !sowing.isAfter(harvest) &&
          harvest.difference(sowing).inDays >= 30;
    } catch (e) {
      return false;
    }
  }
}
