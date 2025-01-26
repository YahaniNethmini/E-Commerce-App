import 'package:e_commerce_app/theme/theme.dart';
import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();

  int _currentPage = 0;
  final List<OnboardingData> _pages = [
    OnboardingData(
        title: "Discover Latest Trends",
        description: "Explore our vast collection of trendy and fashionable items curated just for you.",
        image: "assets/images/onboarding1.png"
    ),
    OnboardingData(
        title: "Easy Shopping Experience",
        description: "Shop with ease and convenience with our user-friendly interface.",
        image: "assets/images/onboarding2.png"
    ),
    OnboardingData(
        title: "Secure Payment",
        description: "We ensure that your payment is secure and your personal information is kept confidential.",
        image: "assets/images/onboarding3.png"
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
              onPageChanged: (int page) {
                setState(() {
                  _currentPage = page;
                });
              },
              itemCount: _pages.length,
              itemBuilder: (context, index) {
                return OnboardingPage(data: _pages[index]);
              },
          ),
        ],
      ),
    );
  }
}

class OnboardingData {
  final String title;
  final String description;
  final String image;

  const OnboardingData({
    required this.title,
    required this.description,
    required this.image,
  });
}

class OnboardingPage extends StatelessWidget {
  final OnboardingData data;

  const OnboardingPage({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            data.image,
            height: MediaQuery.of(context).size.height * 0.4,
            errorBuilder: (context, error, stackTrace) {
              return Text('Image failed to load: ${data.image}');
            },
          ),
          const SizedBox(height: 48),
          Text(
            data.title,
            style: TextStyle(
              color: AppTheme.primaryColor,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            data.description,
            style: TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 16,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}


