part of '_sidebar.dart';

class SidebarItemModel {
  final String name;
  final String iconPath;
  final SidebarItemType sidebarItemType;
  final List<SidebarSubmenuModel>? submenus;
  final String? navigationPath;
  final bool isPage;

  SidebarItemModel({
    required this.name,
    required this.iconPath,
    this.sidebarItemType = SidebarItemType.tile,
    this.submenus,
    this.navigationPath,
    this.isPage = false,
  }) : assert(
          sidebarItemType != SidebarItemType.submenu ||
              (submenus != null && submenus.isNotEmpty),
          'Sub menus cannot be null or empty if the item type is submenu',
        );
}

class SidebarSubmenuModel {
  final String name;
  final String? navigationPath;
  final bool isPage;

  SidebarSubmenuModel({
    required this.name,
    this.navigationPath,
    this.isPage = false,
  });
}

class GroupedMenuModel {
  final String name;
  final List<SidebarItemModel> menus;

  GroupedMenuModel({
    required this.name,
    required this.menus,
  });
}

enum SidebarItemType { tile, submenu }

List<SidebarItemModel> get _topMenus {
  return <SidebarItemModel>[
    SidebarItemModel(
      // name: 'Dashboard',
      name: l.S.current.dashboard,
      iconPath: 'assets/images/sidebar_icons/home-dash-star.svg',
      navigationPath: '/dashboard',
      // sidebarItemType: SidebarItemType.submenu,
      submenus: [
        // SidebarSubmenuModel(
        //   //name: ' eCommerce Admin',
        //   name: l.S.current.eCommerceAdmin,
        //   navigationPath: 'ecommerce-admin',
        // ),
        // SidebarSubmenuModel(
        //   // name: 'Open AI Admin',
        //   name: l.S.current.openAIAdmin,
        //   navigationPath: 'open-ai-admin',
        // ),
        // SidebarSubmenuModel(
        //   // name: 'ERP Admin',
        //   name: l.S.current.eRPAdmin,
        //   navigationPath: 'erp-admin',
        // ),
        // SidebarSubmenuModel(
        //   //name: 'POS Admin',
        //   name: l.S.current.pOSAdmin,
        //   navigationPath: 'pos-admin',
        // ),
        // SidebarSubmenuModel(
        //   //name: 'Earning Admin',
        //   name: l.S.current.earningAdmin,
        //   navigationPath: 'earning-admin',
        // ),
        // SidebarSubmenuModel(
        //   //name: 'SMS Admin',
        //   name: l.S.current.sMSAdmin,
        //   navigationPath: 'sms-admin',
        // ),
        // SidebarSubmenuModel(
        //   //name: 'Influencer Admin',
        //   name: l.S.current.influencerAdmin,
        //   navigationPath: 'influencer-admin',
        // ),
        // SidebarSubmenuModel(
        //   // name: 'HRM Admin',
        //   name: l.S.current.hRMAdmin,
        //   navigationPath: 'hrm-admin',
        // ),
        // SidebarSubmenuModel(
        //   // name: 'News Admin',
        //   name: l.S.current.newsAdmin,
        //   navigationPath: 'news-admin',
        // ),
      ],
    ),
    // SidebarItemModel(
    //   //name: 'Widgets',
    //   name: l.S.current.widgets,
    //   iconPath: 'assets/images/sidebar_icons/note-list.svg',
    //   sidebarItemType: SidebarItemType.submenu,
    //   navigationPath: '/widgets',
    //   submenus: [
    //     SidebarSubmenuModel(
    //       // name: 'General',
    //       name: l.S.current.general,
    //       navigationPath: 'general-widgets',
    //     ),
    //     SidebarSubmenuModel(
    //       // name: 'Chart',
    //       name: l.S.current.chart,
    //       navigationPath: 'chart-widgets',
    //     ),
    //   ],
    // ),
  ];
}

List<GroupedMenuModel> get _groupedMenus {
  return <GroupedMenuModel>[
    // Application Group
    GroupedMenuModel(
      //name: 'Application',
      name: l.S.current.application,
      menus: [
        // SidebarItemModel(
        //   // name: 'Calendar ',
        //   name: l.S.current.calendar,
        //   iconPath: 'assets/images/sidebar_icons/calendar.svg',
        //   navigationPath: '/calendar',
        // ),
        SidebarItemModel(
          // name: 'Add Product ',
          name: l.S.current.addProduct,
          iconPath: 'assets/images/sidebar_icons/cart.svg',
          navigationPath: '/addProduct',
        ),
        // SidebarItemModel(
        //   // name: 'Add Product ',
        //   name: l.S.current.editProduct,
        //   iconPath: 'assets/images/sidebar_icons/cart.svg',
        //   navigationPath: '/editProduct',
        // ),
        // SidebarItemModel(
        //   //name: 'Chat',
        //   name: l.S.current.chat,
        //   iconPath: 'assets/images/sidebar_icons/chat-text.svg',
        //   navigationPath: '/chat',
        // ),
        // SidebarItemModel(
        //   // name: 'Email',
        //   name: l.S.current.email,
        //   iconPath: 'assets/images/sidebar_icons/envelope.svg',
        //   navigationPath: '/email',
        // ),
        // SidebarItemModel(
        //   //name: 'Projects',
        //   name: l.S.current.projects,
        //   iconPath: 'assets/images/sidebar_icons/copy-check.svg',
        //   navigationPath: '/projects',
        // ),
        // SidebarItemModel(
        //   //name: 'Kanban',
        //   name: l.S.current.kanban,
        //   iconPath: 'assets/images/sidebar_icons/kanban.svg',
        //   navigationPath: '/kanban',
        // ),
          // SidebarItemModel(
          //   //name: "eCommerce",
          //   name: l.S.current.eCommerce,
          //   iconPath: 'assets/images/sidebar_icons/cart.svg',
          //   navigationPath: '/ecommerce',
          //   sidebarItemType: SidebarItemType.submenu,
          //   submenus: [
          //     SidebarSubmenuModel(
          //       // name: "Product List",
          //       name: l.S.current.productList,
          //       navigationPath: "product-list",
          //     ),
          //     SidebarSubmenuModel(
          //       // name: "Product Details",
          //       name: l.S.current.productDetails,
          //       navigationPath: "product-details",
          //     ),
          //     SidebarSubmenuModel(
          //       //name: "Cart",
          //       name: l.S.current.cart,
          //       navigationPath: "cart",
          //     ),
          //     SidebarSubmenuModel(
          //       //name: "Checkout",
          //       name: l.S.current.checkout,
          //       navigationPath: "checkout",
          //     ),
          //   ],
          // ),
        // SidebarItemModel(
        //   //name: "POS & Inventory",
        //   name: l.S.current.POSInventory,
        //   iconPath: 'assets/images/sidebar_icons/pos.svg',
        //   navigationPath: '/pos-inventory',
        //   sidebarItemType: SidebarItemType.submenu,
        //   submenus: [
        //     SidebarSubmenuModel(
        //       // name: "POS Sale",
        //       name: l.S.current.POSSale,
        //       navigationPath: "sale",
        //     ),
        //     SidebarSubmenuModel(
        //       // name: "Sale List",
        //       name: l.S.current.saleList,
        //       navigationPath: "sale-list",
        //     ),
        //     SidebarSubmenuModel(
        //       //name: "Purchase",
        //       name: l.S.current.purchase,
        //       navigationPath: "purchase",
        //     ),
        //     SidebarSubmenuModel(
        //       //name: "Purchase List",
        //       name: l.S.current.purchaseList,
        //       navigationPath: "purchase-list",
        //     ),
        //     SidebarSubmenuModel(
        //       //name: "Product",
        //       name: l.S.current.product,
        //       navigationPath: "product",
        //     ),
        //   ],
        // ),
        // SidebarItemModel(
        //   // name: 'Open AI',
        //   name: l.S.current.openAI,
        //   iconPath: 'assets/images/sidebar_icons/ai.svg',
        //   sidebarItemType: SidebarItemType.submenu,
        //   navigationPath: '/open-ai',
        //   submenus: [
        //     SidebarSubmenuModel(
        //       //name: "AI Writer",
        //       name: l.S.current.aIWriter,
        //       navigationPath: "ai-writter",
        //     ),
        //     SidebarSubmenuModel(
        //       // name: "AI Image",
        //       name: l.S.current.aIImage,
        //       navigationPath: "ai-image",
        //     ),
        //     SidebarSubmenuModel(
        //       // name: "AI Chat",
        //       name: l.S.current.aIChat,
        //       navigationPath: "ai-chat",
        //     ),
        //     SidebarSubmenuModel(
        //       // name: "AI Code",
        //       name: l.S.current.aICode,
        //       navigationPath: "ai-code",
        //     ),
        //     SidebarSubmenuModel(
        //       //name: "AI Voiceover",
        //       name: l.S.current.aIVoiceover,
        //       navigationPath: "ai-voiceover",
        //     ),
        //   ],
        // ),
        // SidebarItemModel(
        //   //name: 'Users',
        //   name: l.S.current.users,
        //   iconPath: 'assets/images/sidebar_icons/users-group.svg',
        //   sidebarItemType: SidebarItemType.submenu,
        //   navigationPath: '/users',
        //   submenus: [
        //     SidebarSubmenuModel(
        //       //name: "Users List",
        //       name: l.S.current.usersList,
        //       navigationPath: "user-list",
        //     ),
        //     SidebarSubmenuModel(
        //       //name: "Users Grid",
        //       name: l.S.current.usersGrid,
        //       navigationPath: "user-grid",
        //     ),
        //     SidebarSubmenuModel(
        //       //name: "User Profile",
        //       name: l.S.current.userProfile,
        //       navigationPath: "user-profile",
        //     ),
        //   ],
        // ),
      ],
    ),

    // Tables & Forms Group
    GroupedMenuModel(
      //name: ' Tables & Forms',
      name: l.S.current.tablesForms,
      menus: [
        SidebarItemModel(
          // name: 'Tables',
          name: l.S.current.tables,
          iconPath: 'assets/images/sidebar_icons/clipboard-text.svg',
          sidebarItemType: SidebarItemType.submenu,
          navigationPath: '/tables',
          submenus: [
            SidebarSubmenuModel(
              //name: "Basic Table",
              name: l.S.current.addedProduct,
              navigationPath: "added-product",
            ),

            // SidebarSubmenuModel(
            //   //name: "Basic Table",
            //   name: l.S.current.editProduct,
            //   navigationPath: "edit-product",
            // ),

            // SidebarSubmenuModel(
            //   //name: "Basic Table",
            //   name: l.S.current.addedTable,
            //   navigationPath: "added-table",
            // ),

            // SidebarSubmenuModel(
            //   //name: "Data Table",
            //   name: l.S.current.dataTable,
            //   navigationPath: "data-table",
            // ),
          ],
        ),
        // SidebarItemModel(
        //   // name: 'Forms',
        //   name: l.S.current.forms,
        //   iconPath: 'assets/images/sidebar_icons/note-list.svg',
        //   sidebarItemType: SidebarItemType.submenu,
        //   navigationPath: '/forms',
        //   submenus: [
        //     SidebarSubmenuModel(
        //       //name: "Basic Forms",
        //       name: l.S.current.basicForms,
        //       navigationPath: 'basic-forms',
        //     ),
        //     SidebarSubmenuModel(
        //       //name: "Form Select",
        //       name: l.S.current.formSelect,
        //       navigationPath: 'form-select',
        //     ),
        //     SidebarSubmenuModel(
        //       // name: "Validation",
        //       name: l.S.current.validation,
        //       navigationPath: 'form-validation',
        //     ),
        //   ],
        // ),
      ],
    ),

    // Components Group
    // GroupedMenuModel(
    //   //name: 'Components',
    //   name: l.S.current.components,
    //   menus: [
    //     SidebarItemModel(
    //       // name: 'Buttons',
    //       name: l.S.current.buttons,
    //       iconPath: 'assets/images/sidebar_icons/checkbox-square-fill.svg',
    //       navigationPath: '/components/buttons',
    //     ),
    //     SidebarItemModel(
    //       //name: 'Colors',
    //       name: l.S.current.colors,
    //       iconPath: 'assets/images/sidebar_icons/palette.svg',
    //       navigationPath: '/components/colors',
    //     ),
    //     SidebarItemModel(
    //       // name: 'Alert',
    //       name: l.S.current.alert,
    //       iconPath: 'assets/images/sidebar_icons/alert-octagon.svg',
    //       navigationPath: '/components/alerts',
    //     ),
    //     SidebarItemModel(
    //       //name: 'Typography',
    //       name: l.S.current.typography,
    //       iconPath: 'assets/images/sidebar_icons/Language.svg',
    //       navigationPath: '/components/typography',
    //     ),
    //     SidebarItemModel(
    //       //name: 'Cards',
    //       name: l.S.current.cards,
    //       iconPath: 'assets/images/sidebar_icons/laptop.svg',
    //       navigationPath: '/components/cards',
    //     ),
    //     SidebarItemModel(
    //       //name: 'Avatars',
    //       name: l.S.current.avatars,
    //       iconPath: 'assets/images/sidebar_icons/user.svg',
    //       navigationPath: '/components/avatars',
    //     ),
    //     SidebarItemModel(
    //       //name: 'Drag & Drop',
    //       name: l.S.current.dragDrop,
    //       iconPath: 'assets/images/sidebar_icons/arrows-move.svg',
    //       navigationPath: '/components/dragndrop',
    //     ),
    //   ],
    // ),

    // Pages
    // GroupedMenuModel(
    //   //name: 'Pages',
    //   name: l.S.current.pages,
    //   menus: [
    //     SidebarItemModel(
    //       // name: 'Authentication',
    //       name: l.S.current.authentication,
    //       iconPath: 'assets/images/sidebar_icons/note-list.svg',
    //       sidebarItemType: SidebarItemType.submenu,
    //       navigationPath: '/authentication',
    //       submenus: [
    //         SidebarSubmenuModel(
    //           //name: "Sign Up",
    //           name: l.S.current.signUp,
    //           navigationPath: 'signup',
    //           isPage: true,
    //         ),
    //         SidebarSubmenuModel(
    //           //name: "Sign In",
    //           name: l.S.current.signIn,
    //           navigationPath: 'signin',
    //           isPage: true,
    //         ),
    //       ],
    //     ),
    //     SidebarItemModel(
    //       // name: 'Gallery',
    //       name: l.S.current.gallery,
    //       iconPath: 'assets/images/sidebar_icons/image-gallery.svg',
    //       navigationPath: '/pages/gallery',
    //     ),
    //     SidebarItemModel(
    //       //name: 'Maps ',
    //       name: l.S.current.maps,
    //       iconPath: 'assets/images/sidebar_icons/map-location.svg',
    //       navigationPath: '/pages/maps',
    //     ),
    //     SidebarItemModel(
    //       //name: 'Pricing',
    //       name: l.S.current.pricing,
    //       iconPath: 'assets/images/sidebar_icons/money-bills.svg',
    //       navigationPath: '/pages/pricing',
    //     ),
    //     SidebarItemModel(
    //       // name: 'FAQs',
    //       name: l.S.current.fAQs,
    //       iconPath: 'assets/images/sidebar_icons/question-square.svg',
    //       navigationPath: '/pages/faqs',
    //     ),
    //     SidebarItemModel(
    //       // name: '404',
    //       name: l.S.current.error,
    //       iconPath: 'assets/images/sidebar_icons/diamond-exclamation.svg',
    //       navigationPath: '/pages/404',
    //       isPage: true,
    //     ),
    //     SidebarItemModel(
    //       // name: 'Tabs & Pills',
    //       name: l.S.current.tabsPills,
    //       iconPath: 'assets/images/sidebar_icons/cursor-click.svg',
    //       navigationPath: '/pages/tabs-and-pills',
    //     ),
    //     SidebarItemModel(
    //       //name: 'Privacy Policy',
    //       name: l.S.current.privacyPolicy,
    //       iconPath: 'assets/images/sidebar_icons/exclamation-circle.svg',
    //       navigationPath: '/pages/privacy-policy',
    //     ),
    //     SidebarItemModel(
    //       //name: 'Terms & Conditions',
    //       name: l.S.current.termsConditions,
    //       iconPath: 'assets/images/sidebar_icons/triangle-exclamation.svg',
    //       navigationPath: '/pages/terms-conditions',
    //     ),
    //   ],
    // ),
  ];
}
