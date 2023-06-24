import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/organization.dart';

class OrganizationInfoPage extends StatelessWidget {
  final Organization organization;

  const OrganizationInfoPage({required this.organization});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          organization.organizationName,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.black),
          softWrap: true,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: "organizationImage${organization.imageUrl}",
              child: Container(
                height: 200.0,
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(organization.imageUrl),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12.0),
                    topRight: Radius.circular(12.0),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    organization.organizationName,
                    style: const TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    organization.description,
                    style: const TextStyle(
                      fontSize: 16.0,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (organization.website.isNotEmpty)
                        InkWell(
                          onTap: () => launchURL(organization.website),
                          child: const Icon(
                            Icons.language,
                            size: 36.0,
                            color: Colors.blue,
                          ),
                        ),
                      if (organization.facebook.isNotEmpty)
                        InkWell(
                          onTap: () => launchURLFacebook(organization.facebook),
                          child: const Icon(
                            Icons.facebook,
                            size: 36.0,
                            color: Colors.blue,
                          ),
                        ),
                      if (organization.email.isNotEmpty)
                        InkWell(
                          onTap: () => launchEmail(organization.email , context),
                          child: const Icon(
                            Icons.email,
                            size: 36.0,
                            color: Colors.blue,
                          ),
                        ),
                      if (organization.phone.isNotEmpty)
                        InkWell(
                          onTap: () => launchPhone(organization.phone , context),
                          child: const Icon(
                            Icons.phone,
                            size: 36.0,
                            color: Colors.blue,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  if (organization.address.isNotEmpty)
                    Text(
                      'Address: ${organization.address}',
                      style: const TextStyle(
                        fontSize: 14.0,
                        color: Colors.grey,
                      ),
                    ),
                  if (organization.fax.isNotEmpty)
                    Text(
                      'Fax: ${organization.fax}',
                      style: const TextStyle(
                        fontSize: 14.0,
                        color: Colors.grey,
                      ),
                    ),
                  if (organization.foundingYear.isNotEmpty)
                    Text(
                      'Founding Year: ${organization.foundingYear}',
                      style: const TextStyle(
                        fontSize: 14.0,
                        color: Colors.grey,
                      ),
                    ),
                  if (organization.guidestar.isNotEmpty)
                    RichText(
                      text: TextSpan(
                        text: 'Guidestar: ',
                        style: const TextStyle(
                          fontSize: 14.0,
                          color: Colors.grey,
                        ),
                        children: [
                          TextSpan(
                            text: organization.guidestar,
                            style: const TextStyle(
                              fontSize: 14.0,
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                launchURL(organization.guidestar);
                              },
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 16.0),
                  const Text(
                    'Services:',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  if (organization.services.isNotEmpty)
                    Table(
                      columnWidths: const {
                        0: FlexColumnWidth(2),
                        1: FlexColumnWidth(3),
                      },
                      children: organization.services
                          .map(
                            (service) => TableRow(
                          children: [
                            TableCell(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  bottom: 8.0,
                                  right: 4.0,
                                ),
                                child: Text(
                                  service,
                                  style: const TextStyle(
                                    fontSize: 14.0,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                          .toList(),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }

  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((MapEntry<String, String> e) =>
    '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }

  void launchURLFacebook(String url) async {
    final facebookURL = url;
    if (await canLaunch(facebookURL)) {
      await launch(facebookURL);
    } else {
      throw 'Could not launch $facebookURL';
    }
  }


  void launchEmail(String email, BuildContext context) async {
    Clipboard.setData(ClipboardData(text: email));
    showToast('Email copied to clipboard');

    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: email,
      query: encodeQueryParameters(<String, String>{
        'subject': 'Example Subject & Symbols are allowed!',
      }),
    );
    await launchUrl(emailLaunchUri);
  }

  void launchPhone(String phoneNumber, BuildContext context) async {
    Clipboard.setData(ClipboardData(text: phoneNumber));
    showToast('Phone number copied to clipboard');

    final Uri launchUri = Uri.parse('tel:$phoneNumber');
    await launchUrl(launchUri);
  }

  void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.grey[800],
      textColor: Colors.white,
    );
  }
}
