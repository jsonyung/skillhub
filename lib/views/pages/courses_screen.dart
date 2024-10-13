import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../models/product_model.dart';
import '../../view_models/courses_viewmodel.dart';
import '../../res/assets_res.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../widgets/filter_bottomsheet.dart';

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key});

  @override
  CoursesScreenState createState() => CoursesScreenState();
}

class CoursesScreenState extends State<CoursesScreen> {
  int selectedTabIndex = 0; // To track the selected tab index
  late ScrollController _scrollController;
  final FocusNode _searchFocusNode = FocusNode(); // FocusNode for the search bar
  final TextEditingController _searchController = TextEditingController(); // TextEditingController for the search bar

  // Method to programmatically focus the search bar
  void focusSearchBar() {
    _searchFocusNode.requestFocus();
  }
  @override
  void initState() {
    super.initState();

    // Delay fetching data until after the first frame is rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = Provider.of<CoursesViewModel>(context, listen: false);
      viewModel.fetchProducts();    // Fetch products on screen load
      viewModel.fetchCategories();  // Fetch categories in advance
      viewModel.loadUserData();     // Load the user data (new step)
    });

    _scrollController = ScrollController();
    _scrollController.addListener(() {
      final viewModel = Provider.of<CoursesViewModel>(context, listen: false);
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        viewModel.fetchProducts().then((_) {
          if (viewModel.isFiltered) {
            viewModel.applyFilters();  // Apply filters after fetching new products
          }
        });
      }
    });
  }



  @override
  void dispose() {
    _scrollController.dispose();
    _searchFocusNode.dispose(); // Dispose the FocusNode
    _searchController.dispose(); // Dispose the TextEditingController
    super.dispose();
  }
  // Build the filter bottom sheet inside the same screen
  void _showFilterBottomSheet(BuildContext context) {
    final viewModel = Provider.of<CoursesViewModel>(context, listen: false);
    // Clear the search text when the filter is opened
    _searchController.clear();
    viewModel.searchProducts('');
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      builder: (context) {
        return FilterBottomSheet(); // Display the bottom sheet
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<CoursesViewModel>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 50), // Add space for the status bar
            _buildHeader(), // Custom Title and Profile Image
            const SizedBox(height: 10),
            _buildSearchAndFilterBar(viewModel),
            const SizedBox(height: 20),
            // Conditionally show Language, Painting cards, and "Choice your course" only if no filter is applied
            if (viewModel.isFiltered||viewModel.searchQuery.isNotEmpty) ...[
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: Text(
                  "Results",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
            ] else ...[
              _buildDefaultUI(viewModel), // Build default UI when no filter is applied
            ],
            const SizedBox(height: 16),
            // Product List
            Expanded(
              child: Consumer<CoursesViewModel>(
                builder: (context, viewModel, child) {
                  if (viewModel.isLoading && viewModel.products.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (viewModel.products.isEmpty && viewModel.isFiltered) {
                    return const Center(
                      child: Text(
                        "Product not available", // Show this when no products match the filter
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    );
                  }

                  return ListView.builder(
                    controller: _scrollController,
                    itemCount: viewModel.products.length + (viewModel.isLoading ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == viewModel.products.length) {
                        return const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }

                      final product = viewModel.products[index];
                      return _buildProductCard(product);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Course",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          // Display the user's profile picture or default user icon
          Consumer<CoursesViewModel>(
            builder: (context, viewModel, child) {
              final user = viewModel.currentUser;
              final photoUrl = user?.photoUrl;

              return Container(
                height: 48,
                width: 48,
                decoration: const BoxDecoration(shape: BoxShape.circle),
                child: ClipOval(
                  child: photoUrl != null
                      ? CachedNetworkImage(
                    imageUrl: photoUrl,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const CircularProgressIndicator(),
                    errorWidget: (context, url, error) => SvgPicture.asset(AssetsRes.USER),
                  )
                      : SvgPicture.asset(AssetsRes.USER), // Default user icon if no profile picture
                ),
              );
            },
          ),
        ],
      ),
    );
  }


  Widget _buildSearchAndFilterBar(CoursesViewModel viewModel) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4), // Reduce vertical padding
      decoration: BoxDecoration(
        color: const Color(0xFFF0F0F0), // More defined light grey background color
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            AssetsRes.SEARCH, // SVG path for search icon
            height: 20,
            width: 20,
            color: const Color(0xFF9E9E9E), // Slightly darker grey for visibility
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _searchController,
              focusNode: _searchFocusNode,
              onChanged: (value) {
                viewModel.searchProducts(value); // Call the search method on input change
              },
              decoration: const InputDecoration(
                hintText: "Find Course",
                hintStyle: TextStyle(
                  color: Color(0xFF9E9E9E), // Grey color for hint text
                ),
                border: InputBorder.none, // No underline
              ),
            ),
          ),
          GestureDetector(
            onTap: () => _showFilterBottomSheet(context), // Open filter bottom sheet
            child: SvgPicture.asset(
              AssetsRes.FILTER, // SVG path for filter icon
              height: 20,
              width: 20,
              color: const Color(0xFF9E9E9E), // Same grey color for visibility
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildDefaultUI(CoursesViewModel viewModel) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildCategoryCard('Language', AssetsRes.LANGUAGE, Colors.blue, Colors.blue),
            _buildCategoryCard('Painting', AssetsRes.PAINTING, Colors.orange, Colors.deepPurple),
          ],
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Choice your course",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              _buildTabView(viewModel),  // Pass viewModel to _buildTabView
            ],
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildTabView(CoursesViewModel viewModel) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _buildTabItem("All", 0, viewModel),
        const SizedBox(width: 12),
        _buildTabItem("Popular", 1, viewModel),
        const SizedBox(width: 12),
        _buildTabItem("New", 2, viewModel),
      ],
    );
  }

  Widget _buildTabItem(String title, int index, CoursesViewModel viewModel) {
    bool isSelected = selectedTabIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTabIndex = index;  // Update the local tab index
          viewModel.setSelectedTabIndex(index);  // Set the selected tab index in the view model
          viewModel.filterProductsByRating(index);  // Filter products based on the selected tab (All, Popular, New)
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF4D5DFB) : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: isSelected ? Colors.transparent : Colors.grey.shade300),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.white : Colors.grey,
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryCard(String title, String svgPath, Color bgColor, Color textColor) {
    return Container(
      width: 160,
      height: 80,
      decoration: BoxDecoration(
        color: bgColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            child: SvgPicture.asset(svgPath, height: 110, width: 110),
          ),
          Positioned(
            bottom: 10,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
              ),
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(Product product) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6,horizontal:10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            spreadRadius: 4,
          ),
        ],
      ),
      child: Row(
        children: [
          CachedNetworkImage(
            imageUrl: product.thumbnail,
            height: 68,
            width: 68,
            placeholder: (context, url) => const SizedBox(height:20 ,width: 20,child: Center(child: CircularProgressIndicator( strokeWidth: 4,))),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '\$${product.price}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color:  Color(0xFF4D5DFB)
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Category Chip with orange background
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.orange[800], // Set category background to orange
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Text(
                  product.category, // Category text
                  style: const TextStyle(
                    color: Colors.white, // White text color
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Rating Chip with star icon and rating number
              Row(
                children: [
                  const Icon(
                    Icons.star, // Star icon
                    color: Colors.orange, // Star color
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${product.rating}', // Product rating
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }


}
