import 'package:google_generative_ai/google_generative_ai.dart';

import '../models/responses/weather_response.dart';

class GeminiService {
  final String apiKey = 'AIzaSyDK4TME_6YPTDBvteVSuoyA05cBgRueiYQ';
  final String modelName = 'gemini-1.5-flash-latest';

  Future<String> getCropRecommendations({
    required String cropName,
    required String growthStage,
    required DateTime? sowingDate,
    required DateTime? harvestDate,
    required String fertilizer,
    required String pesticide,
    required String temperature,
    required String humidity,
    String? weatherDescription,
    String? location,
  }) async {
    try {
      if (!_validateDates(sowingDate, harvestDate)) {
        return 'Invalid sowing or harvest date. Sowing date cannot be after harvest date, and the duration must be reasonable (at least 30 days).';
      }

      final model = GenerativeModel(model: modelName, apiKey: apiKey);

      final htmlPrompt = '''
You are an expert agricultural advisor. Based on the information below, generate a detailed crop advisory in pure HTML format with embedded CSS for styling. 
Use tags like <h2>, <ul>, <li>, <strong>, <p>, etc. Style the headings, sections, and bullet points. Use emojis where relevant. 
Do not include any AI disclaimers or intros.
.Add also excepted harvesting date based on starting date.also suggest fertilizer and pesticide that user do not select, 
if given fertilizer or pesticide is not relevant.
 If the crop name is not recognized or is gibberish (e.g., 'vdhe', 'fbffh'), display only:
  "<strong>Sorry, the crop name you entered is not recognized. Please provide a correct crop name.</strong>"
if you found name of crop that is does not exist just  say "Sorry , you enter wrong crop."other vise if you understand entered name based on your knowledge confirm first like i think you are askinhg about this crop 
if you found name that is not related  so far from any of crops name say sorry message  , do no assume that much once you say sorry then do not give any  advisory
once you found  unrecognized name just give message of groth stage advisory only not give any tips.
if you  found  base on stage  harvesting date is not proper selected calulate baase on user input  and tell th date in Strong tagconsider  sowingDate as start date and harvestDate as harvesting date and take assuption of dates.
<p>Based on current input, the crop is in its early/growing phase. Please enter a valid crop name for a complete advisory.</p>
I have a sowing date: $sowingDate, and i am assume expect harvest date will be $harvestDate .
Can you calculate and return the expected harvest date in DD Month YYYY format?
se only  this color 4EA673
Include the following CSS:
- h2 with green color and margin
- ul with spacing
- li with padding and emoji styling
- paragraphs with readable font size

<html>
<head>
<style>
  body {
    font-family: Lato, Lato;
   
  }
  h2 {
    color: #4EA673;
 
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

      return response.text ?? 'No recommendations received';
    } catch (e) {
      return 'Failed to generate recommendations: $e';
    }
  }

  //liveStock recommendation

  Future<String> getLiveStockRecommendations({
    required String livestockName,
    required String livestockType,
    required String livestockPurpose,
    required String gender,
    required int age,
    required DateTime? vaccinationDate,
  }) async {
    try {
      final model = GenerativeModel(model: modelName, apiKey: apiKey);

      final htmlPrompt = '''
You are an expert livestock advisor. Based on the information below, generate a detailed livestock advisory in pure HTML format with embedded CSS for styling. 
Use tags like <h2>, <ul>, <li>, <strong>, <p>, etc. Style the headings, sections, and bullet points. Use emojis where relevant. Do not include any AI disclaimers or intros.
Include an expected maturity or production milestone (e.g., milking start, slaughter readiness) based on the livestock's age and purpose. Suggest alternative supplements, treatments, or care practices if the provided data (e.g., livestock type or purpose) seems irrelevant or insufficient. If the livestock name or type does not exist or is unclear, state "<strong>Sorry, the entered livestock type or name seems incorrect.</strong>" Otherwise, confirm the livestock type with "<strong>I think you are referring to $livestockType (e.g., $livestockName).</strong>"make sure livestock name is just nme given by user of their livestock and do not give too much  descriptive of content 

<html>
<head>
<style>
  body {
    font-family: Lato, Lato;
  }
  h2 {
    color: #2e7d32;
    margin: 20px 0 10px;
  }
  ul {
    margin: 10px 0;
    padding-left: 20px;
  }
  li {
    margin-bottom: 8px;
    padding: 5px;
    font-size: 16px;
  }
  p {
    font-size: 16px;
    margin: 10px 0;
  }
</style>
</head>
<body>

<h2>🐄 Livestock Health Advisory</h2>
<p><strong>I think you are referring to $livestockType (e.g., $livestockName).</strong> For a <strong>$gender $livestockType</strong> of age <strong>$age months</strong> with purpose <strong>$livestockPurpose</strong>, here’s what you need to know about its current health needs. Discuss general care, common health risks, and mitigation strategies.</p>

<h2>🍽️ Feeding and Nutrition Plan</h2>
<ul>
  <li>Recommended feeding schedule (frequency, quantity) for $livestockType aimed at $livestockPurpose 🕒</li>
  <li>Key nutrients to monitor (e.g., protein, minerals) 📊</li>
  <li>Suggested supplements or alternative feeds if current diet is insufficient 🌾</li>
</ul>

<h2>💉 Vaccination and Disease Prevention</h2>
<ul>
  <li>Status based on last vaccination date ($vaccinationDate) 💉</li>
  <li>Common diseases for $livestockType at this age and purpose 🦠</li>
  <li>Preventive measures and treatments (dosage, timing) 🩺</li>
</ul>

<h2>🌡️ Environmental Impact Analysis</h2>
<p>Discuss how the current environment affects the livestock’s health and productivity, with recommendations for shelter or care adjustments based on $livestockType and $livestockPurpose.</p>

<h2>🧑‍🐄 Action Plan (Next 2–4 Weeks)</h2>
<ul>
  <li>Priority tasks (e.g., health checks, feed adjustments) 📋</li>
  <li>⚠️ Mistakes to avoid (e.g., overfeeding, neglecting vaccinations) 🚫</li>
  <li>✅ Tips to improve productivity or health (e.g., for $livestockPurpose) 🌟</li>
</ul>

<h2>📅 Expected Milestone</h2>
<p>Based on the age ($age months) and purpose ($livestockPurpose), estimate the expected milestone (e.g., start of milking, readiness for slaughter, or breeding maturity) for this $livestockType. Provide a timeline and preparation tips.</p>

</body>
</html>
''';

      final content = [Content.text(htmlPrompt)];
      final response = await model.generateContent(content);

      return response.text ?? 'No recommendations received';
    } catch (e) {
      return 'Failed to generate recommendations: $e';
    }
  }

  bool _validateDates(DateTime? sowingDate, DateTime? harvestDate) {
    try {
      final sowing = sowingDate;
      final harvest = harvestDate;
      return !sowing!.isAfter(harvest!) &&
          harvest.difference(sowing).inDays >= 15;
    } catch (e) {
      return false;
    }
  }

  Future<String> getFarmAdvice(String location, String locationDescription ) async {
    try {
      final model = GenerativeModel(model: modelName, apiKey: apiKey);

      final prompt = '''
You are a smart farming assistant.
Based on the following location and weather of that location , give a short 1-line farming advice.if you found ciy name that is not present you can say wrong city name

State: $location
address : $locationDescription

Respond in 1 line, practical and specific.
''';

      final content = [Content.text(prompt)];
      final response = await model.generateContent(content);

      return response.text ?? 'No recommendations received';
    } catch (e) {
      return 'Failed to generate recommendations: $e';
    }
  }
}
