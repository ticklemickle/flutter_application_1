import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/foundation.dart';

class MuscleContainer extends StatelessWidget {
  final String title;
  final String subtitle;
  final String cardImage;
  final String cardText;
  final String mainContent1;
  final String mainContent2;
  final String subContent;
  final String? websiteUrl;

  const MuscleContainer({
    super.key,
    required this.title,
    required this.subtitle,
    required this.cardImage,
    required this.cardText,
    required this.mainContent1,
    required this.mainContent2,
    required this.subContent,
    this.websiteUrl,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (websiteUrl != null && websiteUrl!.isNotEmpty) {
          final Uri url = Uri.parse(websiteUrl!);
          if (await canLaunchUrl(url)) {
            await launchUrl(url, mode: LaunchMode.externalApplication);
          } else {
            _showToast(context, "URL을 열 수 없습니다.");
          }
        } else {
          _showToast(context, "서비스 준비중입니다.");
        }
      },
      child: Container(
        padding: const EdgeInsets.fromLTRB(8, 8, 16, 20),
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _TitleSection(title: title, subtitle: subtitle),
            _CardImageSection(cardImage: cardImage, cardText: cardText),
            _ContentSection(
                mainContent1: mainContent1,
                mainContent2: mainContent2,
                subContent: subContent),
          ],
        ),
      ),
    );
  }
}

class _TitleSection extends StatelessWidget {
  final String title;
  final String subtitle;

  const _TitleSection({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.normal),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}

class _CardImageSection extends StatelessWidget {
  final String cardImage;
  final String cardText;

  const _CardImageSection({required this.cardImage, required this.cardText});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.zero,
      child: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            height: 300,
            child: Image.asset(
              cardImage,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: double.infinity,
                  height: 200,
                  color: Colors.white,
                  child: const Center(
                    child: Icon(
                      Icons.image_not_supported,
                      color: Colors.grey,
                      size: 50,
                    ),
                  ),
                );
              },
            ),
          ),
          Positioned(
            top: 10,
            right: 10,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.zero,
              ),
              child: Text(
                cardText,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ContentSection extends StatelessWidget {
  final String mainContent1;
  final String mainContent2;
  final String subContent;

  const _ContentSection(
      {required this.mainContent1,
      required this.mainContent2,
      required this.subContent});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 12, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          Text(
            mainContent1,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            mainContent2,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(subContent),
        ],
      ),
    );
  }
}

void _showToast(BuildContext context, String message) {
  // 웹에서는 fluttertoast 대신 ScaffoldMessenger 사용
  if (kIsWeb) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  } else {
    Fluttertoast.showToast(msg: message); // 네이티브 플랫폼에서 fluttertoast 사용
  }
}
