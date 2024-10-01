import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart'; 

class Privacy extends StatelessWidget {
  const Privacy({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Privacy Policy"),
      ),
      body: SingleChildScrollView( // Remove const
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Privacy Policy",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              Text(
                "Your privacy is important to us. This Privacy Policy explains how we collect, use, and share your information when you use our Tuberculosis Detection App.",
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.justify
              ),
              const SizedBox(height: 16),
              Text(
                "Information We Collect:",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 8),
              Text(
                "We collect the chest X-ray images you upload for the purpose of tuberculosis detection. We do not collect any personally identifiable information (PII) such as your name, email address, or location.",
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.justify
              ),
              // ... Add more sections as needed (e.g., Data Use, Data Sharing, Security)
              const SizedBox(height: 16),
              RichText(
                text: TextSpan(
                  style: Theme.of(context).textTheme.bodyMedium,
                  children: <TextSpan>[
                    const TextSpan(
                      text: 'By using this app, you agree to our ',
                    ),
                    TextSpan(
                      text: 'Terms of Service',
                      style: const TextStyle(color: Colors.blue),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () async {
                          Navigator.pushNamed(context, "TermsAndCondition");
                        },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
