import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  String selectedCountry = "+91";
  TextEditingController _numberEditingController = TextEditingController();
  TextEditingController _messageEditingController = TextEditingController();
  GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      appBar: AppBar(
        title: const Text(
          "Chat2x",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 30,
                  child: CountryCodePicker(
                    initialSelection: "IN",
                    favorite: ["+91", "IN"],
                    onChanged: (item) {
                      setState(() {
                        selectedCountry = item.dialCode ?? "+91";
                      });
                    },
                  ),
                ),
                Expanded(
                  flex: 70,
                  child: TextField(
                    controller: _numberEditingController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      hintText: "Enter Mobile Number",
                      labelText: "Mobile Number",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            TextField(
              minLines: 3,
              maxLines: 10,
              controller: _messageEditingController,
              decoration: const InputDecoration(
                hintText: "Enter Message",
                labelText: "Message",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: sendMessage,
              child: const Text("Send Message"),
            ),
          ],
        ),
      ),
    );
  }

  void sendMessage() {
    String number, message;

    // Validate phone number
    if (_numberEditingController.text.isEmpty ||
        _numberEditingController.text.length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter a valid Mobile Number")),
      );
      return;
    }

    // Construct the full phone number without '+'
    number = selectedCountry.replaceAll('+', '') +
        _numberEditingController.text.replaceAll(RegExp(r'[^\d]'), '');

    // Get the message
    message = _messageEditingController.text;

    // Construct the WhatsApp URL
    String url =
        "https://api.whatsapp.com/send?phone=$number&text=${Uri.encodeComponent(message)}";

    // Launch the URL
    _launchURL(Uri.parse(url));
  }

  void _launchURL(Uri url) async {
    try {
      bool canLaunchIt = await canLaunchUrl(url);
      if (canLaunchIt) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                "Could not open WhatsApp. Please check if WhatsApp is installed."),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }
}
