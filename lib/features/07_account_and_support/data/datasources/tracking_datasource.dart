import 'package:dio/dio.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/constants/api_endpoints.dart';

abstract class TrackingRemoteDataSource {
  // آرڈر کی ٹریکنگ انفو لائیں
  Future<List<TrackingInfoModel>> getOrderTracking(int orderId);
}

class TrackingRemoteDataSourceImpl implements TrackingRemoteDataSource {
  final ApiClient apiClient;

  TrackingRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<TrackingInfoModel>> getOrderTracking(int orderId) async {
    try {
      // AST Plugin Endpoint usually adds 'shipment_tracking' to orders API response
      // or has a specific endpoint like 'wc-ast/v3/orders/{id}/shipment-tracking'

      // طریقہ 1: آرڈر میٹا ڈیٹا سے ٹریکنگ نکالنا (زیادہ عام طریقہ)
      final response = await apiClient.get(
        'wc/v3/orders/$orderId',
        queryParameters: {
          'consumer_key': ApiEndpoints.consumerKey,
          'consumer_secret': ApiEndpoints.consumerSecret,
        },
      );

      // AST پلگ ان اکثر ٹریکنگ ڈیٹا کو 'meta_data' یا الگ فیلڈ میں بھیجتا ہے
      final metaData = response.data['meta_data'] as List?;

      // ٹریکنگ ڈیٹا تلاش کریں (Key varies by plugin, e.g., '_wc_shipment_tracking_items')
      final trackingMeta = metaData?.firstWhere(
            (meta) => meta['key'] == '_wc_shipment_tracking_items',
        orElse: () => null,
      );

      if (trackingMeta != null && trackingMeta['value'] is List) {
        return (trackingMeta['value'] as List)
            .map((e) => TrackingInfoModel.fromJson(e))
            .toList();
      }

      return []; // کوئی ٹریکنگ نہیں ملی

    } catch (e) {
      // اگر پلگ ان نہیں ہے تو خالی لسٹ
      return [];
    }
  }
}

// --- Tracking Info Model ---
// (یہیں بنا رہے ہیں کیونکہ یہ بہت چھوٹا ماڈل ہے)
class TrackingInfoModel {
  final String trackingId;
  final String provider;
  final String dateShipped;
  final String trackingUrl;

  TrackingInfoModel({
    required this.trackingId,
    required this.provider,
    required this.dateShipped,
    required this.trackingUrl,
  });

  factory TrackingInfoModel.fromJson(Map<String, dynamic> json) {
    return TrackingInfoModel(
      trackingId: json['tracking_number'] ?? '',
      provider: json['tracking_provider'] ?? '',
      dateShipped: json['date_shipped'] ?? '',
      trackingUrl: json['custom_tracking_link'] ?? '', // یا 'tracking_link'
    );
  }
}