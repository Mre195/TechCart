import 'package:flutter/material.dart';
import 'package:project/pages/drawer.dart';
import 'package:project/pages/products.dart';
import 'package:project/pages/photo_slider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    // Dynamic colors for the page
    Color scaffoldBg = isDark ? Colors.black : Colors.green.shade50; // background like other pages
    Color appBarBg = isDark ? Colors.black : Colors.green;
    Color appBarText = Colors.white;
    Color titleText = isDark ? Colors.white : Colors.black; // "Categories" text
    Color cardBg = isDark ? const Color(0xFF1A1A1A) : Colors.white;
    Color cardShadow = Colors.black.withOpacity(0.08);
    Color cardIconBg = const Color(0xFF4F8A63).withOpacity(0.12); // unique icon bg
    Color cardIconColor = const Color(0xFF4F8A63); // unique icon color
    Color cardText = isDark ? Colors.white : Colors.black;

    return Scaffold(
      backgroundColor: scaffoldBg,
      appBar: AppBar(
        backgroundColor: Colors.green,
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 140),
            child: Image.asset(
              "assets/lolg.png",
              height: 100,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
      drawer:AppDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              height: 170,
              child: PromoSlider(
                height: 140,
                images: const [
                  "assets/pa.jpeg",
                  "assets/pa2.jpeg",
                  "assets/pa3.jpeg"
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "Categories",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: titleText,
              ),
            ),
            const SizedBox(height: 14),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              childAspectRatio: 1.15,
              children: [
                _catCard(context, "GPU", Icons.settings_input_component, cardBg, cardShadow, cardIconBg, cardIconColor, cardText),
                _catCard(context, "CPU", Icons.memory, cardBg, cardShadow, cardIconBg, cardIconColor, cardText),
                _catCard(context, "RAM", Icons.storage, cardBg, cardShadow, cardIconBg, cardIconColor, cardText),
                _catCard(context, "Storage", Icons.sd_storage, cardBg, cardShadow, cardIconBg, cardIconColor, cardText),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Widget _catCard(
    BuildContext context,
    String title,
    IconData icon,
    Color bg,
    Color shadow,
    Color iconBg,
    Color iconColor,
    Color textColor,
    ) {
  return InkWell(
    borderRadius: BorderRadius.circular(18),
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ProductsPage(initialCategory: title)),
      );
    },
    child: Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            blurRadius: 14,
            offset: const Offset(0, 8),
            color: shadow,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: iconColor, size: 28),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w900,
              color: textColor,
            ),
          ),
        ],
      ),
    ),
  );
}
