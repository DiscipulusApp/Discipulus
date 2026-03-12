import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class BannerAdWidget extends StatefulWidget {
  const BannerAdWidget({super.key});

  @override
  State<BannerAdWidget> createState() => BannerAdWidgetState();

  static BannerAdWidgetState? of(BuildContext context) =>
      context.findAncestorStateOfType<BannerAdWidgetState>();
}

class BannerAdWidgetState extends State<BannerAdWidget> {
  BannerAd? _bannerAd;
  bool _isLoaded = false;

  bool isEnabled() {
    return _isLoaded;
  }

  // Use test ID for iOS banner in debug mode.
  final String adUnitId = Platform.isIOS
      ? (kDebugMode
          ? 'ca-app-pub-3940256099942544/2934735716'
          : 'ca-app-pub-8698376572242605/3132367970')
      : '';

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (Platform.isIOS && _bannerAd == null) {
      _loadAd();
    }
  }

  void _loadAd() async {
    if (!mounted) return;
    // Get the adaptive banner size, accounting for safe area width to avoid rounding issues.
    final double safeWidth = MediaQuery.of(context).size.width -
        MediaQuery.of(context).padding.left -
        MediaQuery.of(context).padding.right;

    final AnchoredAdaptiveBannerAdSize? size =
        await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
            safeWidth.truncate());

    if (size == null) {
      debugPrint('Unable to get adaptive banner size.');
      return;
    }

    _bannerAd = BannerAd(
      adUnitId: adUnitId,
      request: const AdRequest(),
      size: size,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          debugPrint('$ad loaded.');
          if (!mounted) {
            ad.dispose();
            return;
          }
          setState(() {
            _isLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, err) {
          debugPrint('BannerAd failed to load: $err');
          ad.dispose();
        },
      ),
    )..load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!Platform.isIOS || _bannerAd == null || !_isLoaded) {
      return const SizedBox.shrink();
    }

    return Center(
      child: Container(
        color: Theme.of(context).colorScheme.surface,
        width: _bannerAd!.size.width.toDouble(),
        height: _bannerAd!.size.height.toDouble(),
        child: AdWidget(ad: _bannerAd!),
      ),
    );
  }
}
