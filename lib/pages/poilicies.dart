import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ConstructionRegulationsPage extends StatefulWidget {
  const ConstructionRegulationsPage({super.key});

  @override
  State<ConstructionRegulationsPage> createState() => _ConstructionRegulationsPageState();
}

class _ConstructionRegulationsPageState extends State<ConstructionRegulationsPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();
  final double _sectionSpacing = 24.0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void scrollToSection(String sectionId) {
    final offsets = {
      'cameroon-laws': 300.0,
      'international-standards': 1000.0,
      'building-codes': 1700.0,
      'regulatory-bodies': 2400.0,
    };

    if (offsets.containsKey(sectionId)) {
      _scrollController.animateTo(
        offsets[sectionId]!,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = const Color(0xFF121212);
    final cardColor = const Color(0xFF1E1E1E);
    final textColor = Colors.white;
    final subtitleColor = const Color(0xFFA0A0A0);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // Header Section
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Column(
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF00C853), Color(0xFF009688)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(36),
                    ),
                    child: const Icon(
                      Icons.engineering,
                      color: Colors.white,
                      size: 36,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Réglementations & Normes',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: textColor,
                      fontSize: 24,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Lois camerounaises et standards internationaux pour la construction',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: subtitleColor,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),

          // Quick Navigation
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            sliver: SliverToBoxAdapter(
              child: Card(
                color: cardColor,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Navigation Rapide',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(height: 16),
                      GridView.count(
                        crossAxisCount: 1,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: 3.2,
                        children: [
                          _buildNavButton(
                            context: context,
                            icon: Icons.flag,
                            title: 'Lois Camerounaises',
                            onTap: () => scrollToSection('cameroon-laws'),
                          ),
                          _buildNavButton(
                            context: context,
                            icon: Icons.public,
                            title: 'Normes Internationales',
                            onTap: () => scrollToSection('international-standards'),
                          ),
                          _buildNavButton(
                            context: context,
                            icon: Icons.business,
                            title: 'Codes du Bâtiment',
                            onTap: () => scrollToSection('building-codes'),
                          ),
                          _buildNavButton(
                            context: context,
                            icon: Icons.store,
                            title: 'Organismes',
                            onTap: () => scrollToSection('regulatory-bodies'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Cameroon Construction Laws
          _buildSectionHeader(
            icon: Icons.flag,
            title: 'Lois de Construction',
            subtitle: 'Cadre juridique national',
            gradientColors: const [Color(0xFF00C853), Color(0xFF009688)],
            textColor: textColor,
            subtitleColor: subtitleColor,
          ),
          
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: index == cameroonLaws.length - 1 ? 0 : 16),
                    child: _buildLawCard(
                      context: context,
                      law: cameroonLaws[index],
                      cardColor: cardColor,
                      textColor: textColor,
                      subtitleColor: subtitleColor,
                    ),
                  );
                },
                childCount: cameroonLaws.length,
              ),
            ),
          ),

          SliverToBoxAdapter(child: SizedBox(height: _sectionSpacing)),

          // International Standards
          _buildSectionHeader(
            icon: Icons.public,
            title: 'Normes Internationales',
            subtitle: 'Standards mondiaux',
            gradientColors: const [Color(0xFF2979FF), Color(0xFF2962FF)],
            textColor: textColor,
            subtitleColor: subtitleColor,
          ),

          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: index == standardCategories.length - 1 ? 0 : 16),
                    child: _buildStandardCategoryCard(
                      context: context,
                      category: standardCategories[index],
                      cardColor: cardColor,
                      textColor: textColor,
                      subtitleColor: subtitleColor,
                    ),
                  );
                },
                childCount: standardCategories.length,
              ),
            ),
          ),

          SliverToBoxAdapter(child: SizedBox(height: _sectionSpacing)),

          // Building Codes
          _buildSectionHeader(
            icon: Icons.business,
            title: 'Codes du Bâtiment',
            subtitle: 'Réglementations techniques',
            gradientColors: const [Color(0xFFD500F9), Color(0xFFAA00FF)],
            textColor: textColor,
            subtitleColor: subtitleColor,
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Card(
                color: cardColor,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    TabBar(
                      controller: _tabController,
                      isScrollable: true,
                      labelPadding: const EdgeInsets.symmetric(horizontal: 24),
                      tabs: const [
                        Tab(text: 'Structurels'),
                        Tab(text: 'Sécurité'),
                        Tab(text: 'Environnementaux'),
                      ],
                      labelColor: Theme.of(context).colorScheme.primary,
                      unselectedLabelColor: subtitleColor,
                      indicatorColor: Theme.of(context).colorScheme.primary,
                    ),
                    SizedBox(
                      height: 380,
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          _buildCodesTabContent(
                            context: context,
                            codes: structuralCodes,
                            textColor: textColor,
                            subtitleColor: subtitleColor,
                          ),
                          _buildCodesTabContent(
                            context: context,
                            codes: safetyCodes,
                            textColor: textColor,
                            subtitleColor: subtitleColor,
                          ),
                          _buildCodesTabContent(
                            context: context,
                            codes: environmentalCodes,
                            textColor: textColor,
                            subtitleColor: subtitleColor,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(child: SizedBox(height: _sectionSpacing)),

          // Regulatory Bodies
          _buildSectionHeader(
            icon: Icons.store,
            title: 'Organismes Régulateurs',
            subtitle: 'Institutions de contrôle',
            gradientColors: const [Color(0xFFFF6D00), Color(0xFFFF3D00)],
            textColor: textColor,
            subtitleColor: subtitleColor,
          ),

          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: index == regulatoryBodies.length - 1 ? 0 : 16),
                    child: _buildRegulatoryBodyCard(
                      context: context,
                      body: regulatoryBodies[index],
                      cardColor: cardColor,
                      textColor: textColor,
                      subtitleColor: subtitleColor,
                    ),
                  );
                },
                childCount: regulatoryBodies.length,
              ),
            ),
          ),

          SliverToBoxAdapter(child: SizedBox(height: _sectionSpacing)),

          // Resources & Downloads
          _buildSectionHeader(
            icon: Icons.download,
            title: 'Ressources',
            subtitle: 'Documents et guides',
            gradientColors: const [Color(0xFF00BFA5), Color(0xFF00ACC1)],
            textColor: textColor,
            subtitleColor: subtitleColor,
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Card(
                color: cardColor,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: List.generate(
                      resources.length,
                      (index) => Padding(
                        padding: EdgeInsets.only(bottom: index == resources.length - 1 ? 0 : 12),
                        child: _buildResourceItem(
                          context: context,
                          resource: resources[index],
                          textColor: textColor,
                          subtitleColor: subtitleColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(child: SizedBox(height: _sectionSpacing)),

          // Contact & Support
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF00C853), Color(0xFF009688)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.support_agent,
                      color: Colors.white,
                      size: 40,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Besoin d\'assistance ?',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Nos experts sont disponibles pour vous aider',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      alignment: WrapAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () => _launchUrl('mailto:support@batiment-intelligent.cm'),
                          icon: const Icon(Icons.email, size: 18),
                          label: const Text('Nous Contacter'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: const Color(0xFF009688),
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        OutlinedButton.icon(
                          onPressed: () => _launchUrl('tel:+237123456789'),
                          icon: const Icon(Icons.phone, size: 18),
                          label: const Text('Appeler'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            side: const BorderSide(color: Colors.white),
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavButton({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Material(
      borderRadius: BorderRadius.circular(12),
      color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[300]
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildSectionHeader({
    required IconData icon,
    required String title,
    required String subtitle,
    required List<Color> gradientColors,
    required Color textColor,
    required Color subtitleColor,
  }) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: gradientColors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: subtitleColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLawCard({
    required BuildContext context,
    required Map<String, dynamic> law,
    required Color cardColor,
    required Color textColor,
    required Color subtitleColor,
  }) {
    return Card(
      color: cardColor,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: _getColorFromString(law['bgColor']),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    _getIconData(law['icon']),
                    color: _getColorFromString(law['iconColor']),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        law['title'],
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: textColor,
                        ),
                      ),
                      Text(
                        law['reference'],
                        style: TextStyle(
                          fontSize: 13,
                          color: subtitleColor,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: law['status'] == 'active' 
                        ? const Color(0xFF1B5E20).withValues(alpha: 0.2) 
                        : const Color(0xFFF57F17).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    law['status'] == 'active' ? 'En vigueur' : 'En révision',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: law['status'] == 'active' 
                          ? const Color(0xFF4CAF50) 
                          : const Color(0xFFFFC107),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              law['description'],
              style: TextStyle(
                fontSize: 14,
                color: subtitleColor,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Points clés :',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
            const SizedBox(height: 8),
            Column(
              children: (law['keyPoints'] as List).map((point) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.circle,
                        size: 8,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          point,
                          style: TextStyle(
                            fontSize: 14,
                            color: subtitleColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            const Divider(height: 1, thickness: 0.5),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Mise à jour: ${law['lastUpdated']}',
                  style: TextStyle(
                    fontSize: 12,
                    color: subtitleColor,
                  ),
                ),
                Row(
                  children: [
                    if (law['downloadUrl'] != null)
                      SizedBox(
                        height: 32,
                        child: TextButton.icon(
                          onPressed: () => _launchUrl(law['downloadUrl']),
                          icon: const Icon(Icons.download, size: 16),
                          label: const Text('PDF'),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            textStyle: const TextStyle(fontSize: 13),
                          ),
                        ),
                      ),
                    if (law['downloadUrl'] != null && law['officialUrl'] != null)
                      const SizedBox(width: 8),
                    if (law['officialUrl'] != null)
                      SizedBox(
                        height: 32,
                        child: TextButton.icon(
                          onPressed: () => _launchUrl(law['officialUrl']),
                          icon: const Icon(Icons.link, size: 16),
                          label: const Text('Site'),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            textStyle: const TextStyle(fontSize: 13),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStandardCategoryCard({
    required BuildContext context,
    required Map<String, dynamic> category,
    required Color cardColor,
    required Color textColor,
    required Color subtitleColor,
  }) {
    return Card(
      color: cardColor,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: _getColorFromString(category['bgColor']),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    _getIconData(category['icon']),
                    color: _getColorFromString(category['iconColor']),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  category['title'],
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: textColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              category['description'],
              style: TextStyle(
                fontSize: 14,
                color: subtitleColor,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 16),
            ...(category['standards'] as List).map((standard) {
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF252525) ,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            standard['code'],
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: textColor,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            standard['title'],
                            style: TextStyle(
                              fontSize: 13,
                              color: subtitleColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (standard['url'] != null)
                      IconButton(
                        onPressed: () => _launchUrl(standard['url']),
                        icon: const Icon(Icons.open_in_new, size: 20),
                        color: Theme.of(context).colorScheme.primary,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(
                          minWidth: 36,
                          minHeight: 36,
                        ),
                      ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildCodesTabContent({
    required BuildContext context,
    required List<Map<String, dynamic>> codes,
    required Color textColor,
    required Color subtitleColor,
  }) {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: codes.length,
      itemBuilder: (context, index) {
        final code = codes[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF252525) ,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      code['title'],
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: textColor,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: code['mandatory'] 
                          ? const Color(0xFFB71C1C).withValues(alpha: 0.2) 
                          : const Color(0xFF0D47A1).withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      code['mandatory'] ? 'Obligatoire' : 'Recommandé',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: code['mandatory'] 
                            ? const Color(0xFFF44336) 
                            : const Color(0xFF2196F3),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                code['description'],
                style: TextStyle(
                  fontSize: 14,
                  color: subtitleColor,
                  height: 1.5,
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: Text(
                      code['scope'],
                      style: TextStyle(
                        fontSize: 13,
                        color: subtitleColor,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (code['url'] != null)
                    TextButton(
                      onPressed: () => _launchUrl(code['url']),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        textStyle: const TextStyle(fontSize: 13),
                      ),
                      child: const Text('Voir détails'),
                    ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRegulatoryBodyCard({
    required BuildContext context,
    required Map<String, dynamic> body,
    required Color cardColor,
    required Color textColor,
    required Color subtitleColor,
  }) {
    return Card(
      color: cardColor,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: _getColorFromString(body['bgColor']),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _getIconData(body['icon']),
                    color: _getColorFromString(body['iconColor']),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        body['name'],
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: textColor,
                        ),
                      ),
                      Text(
                        body['acronym'],
                        style: TextStyle(
                          fontSize: 14,
                          color: subtitleColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              body['description'],
              style: TextStyle(
                fontSize: 14,
                color: subtitleColor,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Domaines de compétence :',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: (body['domains'] as List).map((domain) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    domain,
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            const Divider(height: 1, thickness: 0.5),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      body['location'],
                      style: TextStyle(
                        fontSize: 13,
                        color: subtitleColor,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    if (body['website'] != null)
                      IconButton(
                        onPressed: () => _launchUrl(body['website']),
                        icon: const Icon(Icons.public, size: 18),
                        color: Theme.of(context).colorScheme.primary,
                        padding: EdgeInsets.zero,
                      ),
                    if (body['website'] != null && body['contact'] != null)
                      const SizedBox(width: 8),
                    if (body['contact'] != null)
                      IconButton(
                        onPressed: () => _launchUrl('mailto:${body['contact']}'),
                        icon: const Icon(Icons.email, size: 18),
                        color: Theme.of(context).colorScheme.primary,
                        padding: EdgeInsets.zero,
                      ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResourceItem({
    required BuildContext context,
    required Map<String, dynamic> resource,
    required Color textColor,
    required Color subtitleColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF252525),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            _getIconData(resource['icon']),
            color: Theme.of(context).colorScheme.primary,
            size: 24,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  resource['title'],
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  resource['description'],
                  style: TextStyle(
                    fontSize: 13,
                    color: subtitleColor,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        resource['type'].toUpperCase(),
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${resource['size']} • ${resource['language']}',
                      style: TextStyle(
                        fontSize: 12,
                        color: subtitleColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => _launchUrl(resource['downloadUrl']),
            icon: const Icon(Icons.download, size: 24),
            color: Theme.of(context).colorScheme.primary,
          ),
        ],
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Color _getColorFromString(String colorString) {
    final colorMap = {
      'blue': const Color(0xFFBBDEFB),
      'red': const Color(0xFFFFCDD2),
      'green': const Color(0xFFC8E6C9),
      'orange': const Color(0xFFFFE0B2),
      'purple': const Color(0xFFE1BEE7),
    };
    return colorMap[colorString] ?? const Color(0xFFB3E5FC);
  }

  IconData _getIconData(String iconString) {
    final iconMap = {
      'flag': Icons.flag,
      'globe': Icons.public,
      'business': Icons.business,
      'store': Icons.store,
      'download': Icons.download,
      'map': Icons.map,
      'shield': Icons.security,
      'leaf': Icons.eco,
      'science': Icons.science,
      'home': Icons.home,
      'verified': Icons.verified,
      'school': Icons.school,
      'settings': Icons.settings,
      'document': Icons.description,
      'clipboard': Icons.assignment,
      'group': Icons.group,
      'help': Icons.help,
    };
    return iconMap[iconString] ?? Icons.article;
  }
}

// Data
final List<Map<String, dynamic>> cameroonLaws = [
  {
    'id': 'urban-planning-law',
    'title': 'Loi sur l\'Urbanisme et l\'Aménagement',
    'reference': 'Loi N° 2004/003 du 21 avril 2004',
    'description': 'Cette loi régit l\'urbanisme et l\'aménagement du territoire au Cameroun. Elle définit les règles de planification urbaine, les procédures d\'obtention des permis de construire et les normes d\'aménagement.',
    'keyPoints': [
      'Procédures d\'obtention des permis de construire',
      'Normes d\'aménagement urbain et rural',
      'Règles de lotissement et de morcellement',
      'Sanctions en cas de construction illégale'
    ],
    'status': 'active',
    'lastUpdated': '2004',
    'icon': 'map',
    'bgColor': 'bg-blue-100 dark:bg-blue-900',
    'iconColor': 'text-blue-600 dark:text-blue-400',
    'downloadUrl': '#',
    'officialUrl': 'https://www.minduh.gov.cm'
  },
  {
    'id': 'building-safety-code',
    'title': 'Code de Sécurité des Bâtiments',
    'reference': 'Décret N° 2008/0737/PM du 23 avril 2008',
    'description': 'Ce décret établit les normes de sécurité pour la construction des bâtiments, incluant les mesures de prévention incendie, les normes parasismiques et les exigences d\'accessibilité.',
    'keyPoints': [
      'Normes de résistance au feu',
      'Exigences parasismiques',
      'Accessibilité pour personnes handicapées',
      'Systèmes d\'évacuation d\'urgence'
    ],
    'status': 'active',
    'lastUpdated': '2008',
    'icon': 'shield',
    'bgColor': 'bg-red-100 dark:bg-red-900',
    'iconColor': 'text-red-600 dark:text-red-400',
    'downloadUrl': '#',
    'officialUrl': 'https://www.mintp.gov.cm'
  },
];

final List<Map<String, dynamic>> standardCategories = [
  {
    'id': 'iso-standards',
    'title': 'Normes ISO',
    'description': 'Standards internationaux pour la qualité, sécurité et efficacité',
    'icon': 'globe',
    'bgColor': 'bg-blue-100 dark:bg-blue-900',
    'iconColor': 'text-blue-600 dark:text-blue-400',
    'standards': [
      {
        'code': 'ISO 9001',
        'title': 'Systèmes de management de la qualité',
        'url': 'https://www.iso.org/iso-9001-quality-management.html'
      },
      {
        'code': 'ISO 14001',
        'title': 'Systèmes de management environnemental',
        'url': 'https://www.iso.org/iso-14001-environmental-management.html'
      },
      {
        'code': 'ISO 45001',
        'title': 'Systèmes de management de la santé et sécurité au travail',
        'url': 'https://www.iso.org/iso-45001-occupational-health-and-safety.html'
      }
    ]
  },
  {
    'id': 'en-standards',
    'title': 'Normes Européennes (EN)',
    'description': 'Standards européens adoptés par de nombreux pays africains',
    'icon': 'flag',
    'bgColor': 'bg-purple-100 dark:bg-purple-900',
    'iconColor': 'text-purple-600 dark:text-purple-400',
    'standards': [
      {
        'code': 'EN 1990',
        'title': 'Eurocodes - Bases de calcul des structures',
        'url': 'https://eurocodes.jrc.ec.europa.eu'
      },
      {
        'code': 'EN 1991',
        'title': 'Actions sur les structures',
        'url': 'https://eurocodes.jrc.ec.europa.eu'
      },
      {
        'code': 'EN 1992',
        'title': 'Calcul des structures en béton',
        'url': 'https://eurocodes.jrc.ec.europa.eu'
      }
    ]
  },
];

final List<Map<String, dynamic>> structuralCodes = [
  {
    'id': 'concrete-code',
    'title': 'Code du Béton Armé',
    'description': 'Règles de calcul et de dimensionnement des structures en béton armé selon les normes camerounaises et internationales.',
    'scope': 'Bâtiments résidentiels et commerciaux',
    'mandatory': true,
    'url': '#'
  },
  {
    'id': 'steel-code',
    'title': 'Code des Structures Métalliques',
    'description': 'Normes pour la conception, le calcul et la construction des structures en acier.',
    'scope': 'Structures industrielles et commerciales',
    'mandatory': true,
    'url': '#'
  },
];

final List<Map<String, dynamic>> safetyCodes = [
  {
    'id': 'fire-code',
    'title': 'Code de Prévention Incendie',
    'description': 'Mesures de prévention et de protection contre l\'incendie dans les bâtiments.',
    'scope': 'Bâtiments recevant du public',
    'mandatory': true,
    'url': '#'
  },
  {
    'id': 'electrical-code',
    'title': 'Code Électrique',
    'description': 'Normes d\'installation électrique pour assurer la sécurité des occupants.',
    'scope': 'Toutes installations électriques',
    'mandatory': true,
    'url': '#'
  },
];

final List<Map<String, dynamic>> environmentalCodes = [
  {
    'id': 'energy-code',
    'title': 'Code de Performance Énergétique',
    'description': 'Normes d\'efficacité énergétique et d\'isolation thermique des bâtiments.',
    'scope': 'Nouveaux bâtiments',
    'mandatory': false,
    'url': '#'
  },
  {
    'id': 'water-code',
    'title': 'Code de Gestion de l\'Eau',
    'description': 'Règles de gestion des eaux pluviales et de conservation de l\'eau.',
    'scope': 'Tous projets de construction',
    'mandatory': false,
    'url': '#'
  },
];

final List<Map<String, dynamic>> regulatoryBodies = [
  {
    'id': 'mintp',
    'name': 'Ministère des Travaux Publics',
    'acronym': 'MINTP',
    'description': 'Responsable de la réglementation et du contrôle des travaux publics et de la construction au Cameroun.',
    'domains': ['Travaux Publics', 'Construction', 'Infrastructures'],
    'location': 'Yaoundé, Cameroun',
    'icon': 'building-office-2',
    'bgColor': 'bg-blue-100 dark:bg-blue-900',
    'iconColor': 'text-blue-600 dark:text-blue-400',
    'website': 'https://www.mintp.gov.cm',
    'contact': 'info@mintp.gov.cm'
  },
  {
    'id': 'minduh',
    'name': 'Ministère du Développement Urbain et de l\'Habitat',
    'acronym': 'MINDUH',
    'description': 'Chargé de l\'urbanisme, de l\'habitat et du développement urbain durable.',
    'domains': ['Urbanisme', 'Habitat', 'Développement Urbain'],
    'location': 'Yaoundé, Cameroun',
    'icon': 'home',
    'bgColor': 'bg-green-100 dark:bg-green-900',
    'iconColor': 'text-green-600 dark:text-green-400',
    'website': 'https://www.minduh.gov.cm',
    'contact': 'contact@minduh.gov.cm'
  },
];

final List<Map<String, dynamic>> resources = [
  {
    'id': 'urban-planning-guide',
    'title': 'Guide de l\'Urbanisme au Cameroun',
    'description': 'Manuel complet des procédures d\'urbanisme et d\'aménagement',
    'type': 'pdf',
    'size': '2.5 MB',
    'language': 'Français',
    'icon': 'document',
    'downloadUrl': '#'
  },
  {
    'id': 'building-permit-form',
    'title': 'Formulaire de Demande de Permis de Construire',
    'description': 'Formulaire officiel pour les demandes de permis de construire',
    'type': 'pdf',
    'size': '500 KB',
    'language': 'Français',
    'icon': 'document',
    'downloadUrl': '#'
  },
];