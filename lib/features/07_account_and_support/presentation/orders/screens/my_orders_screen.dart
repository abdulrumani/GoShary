import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

// Core Imports
import '../../../../../core/config/app_colors.dart';
import '../../../../../core/navigation/route_names.dart';
import '../../../../../core/services/di_container.dart';
import '../../../../../core/widgets/loading_indicator.dart';

// Feature Imports
import '../../../../05_checkout/domain/entities/order.dart';
import '../cubit/order_cubit.dart';
import '../cubit/order_state.dart';
import '../widgets/order_card.dart';

class MyOrdersScreen extends StatelessWidget {
  const MyOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<OrderCubit>()..loadOrders(),
      child: const _MyOrdersView(),
    );
  }
}

class _MyOrdersView extends StatelessWidget {
  const _MyOrdersView();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBackground,
        appBar: AppBar(
          title: const Text("My Orders"),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => context.pop(),
          ),
          bottom: const TabBar(
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textSecondary,
            indicatorColor: AppColors.primary,
            tabs: [
              Tab(text: "Active"),
              Tab(text: "Completed"),
              Tab(text: "Cancelled"),
            ],
          ),
        ),
        body: BlocBuilder<OrderCubit, OrderState>(
          builder: (context, state) {
            if (state is OrderLoading) {
              return const Center(child: LoadingIndicator());
            } else if (state is OrderError) {
              return Center(child: Text(state.message));
            } else if (state is OrderLoaded) {
              final allOrders = state.orders;

              if (allOrders.isEmpty) {
                return const Center(child: Text("No orders found."));
              }

              // Filter Lists
              final activeOrders = allOrders.where((o) =>
              o.status == 'processing' || o.status == 'pending' || o.status == 'on-hold').toList();

              final completedOrders = allOrders.where((o) =>
              o.status == 'completed').toList();

              final cancelledOrders = allOrders.where((o) =>
              o.status == 'cancelled' || o.status == 'failed' || o.status == 'refunded').toList();

              return TabBarView(
                children: [
                  _buildOrderList(context, activeOrders),
                  _buildOrderList(context, completedOrders),
                  _buildOrderList(context, cancelledOrders),
                ],
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _buildOrderList(BuildContext context, List<OrderEntity> orders) {
    if (orders.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox_outlined, size: 60, color: Colors.grey),
            SizedBox(height: 10),
            Text("No orders in this category", style: TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        return OrderCard(
          order: orders[index],
          onTap: () {
            // Navigate to Order Details (اگر آپ نے بنایا ہو، ورنہ اسے کمنٹ کر دیں)
            // context.pushNamed(RouteNames.orderDetails, extra: orders[index]);
          },
        );
      },
    );
  }
}