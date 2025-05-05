import 'package:custom_faqs/view_models/custom_faq.service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:line_icons/line_icons.dart';

class FaqPage extends StatefulWidget {
  const FaqPage({this.title = "FAQs", this.link, Key? key})
      : super(key: key);

  final String title;
  final String? link;
  @override
  State<FaqPage> createState() => _FaqPageState();
}

class _FaqPageState extends State<FaqPage> {
  //
  int? openedFaq;

  @override
  Widget build(BuildContext context) {
    //
    final customFaqService = CustomFaqService(link: widget.link);
    //
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          child: const Icon(
            LineIcons.arrowLeft,
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Container(
            height: 250,
            width: MediaQuery.of(context).size.width,
            child: Image.asset("assets/images/faqs.png",fit: BoxFit.fill,),
          ),
          Expanded(
            child: FutureBuilder(
              future: customFaqService.fetchFaqs(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                //loading
                if (!snapshot.hasData &&
                    snapshot.connectionState == ConnectionState.waiting) {
                  return const Padding(
                    padding: EdgeInsets.all(20),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                } else {
                  return ListView.separated(
                    itemCount: snapshot.data.length,
                    itemBuilder: (ctx, index) {
                      final faq = snapshot.data[index];
                      return ListTile(
                        title: Text(
                          faq.title,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        subtitle: (openedFaq == index)
                            ? Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 20),
                          child: HtmlWidget(
                            faq.body,
                          ),
                        )
                            : null,
                        trailing: Icon(
                          (openedFaq != index)
                              ? LineIcons.chevronCircleDown
                              : LineIcons.chevronCircleUp,
                          size: 18,
                        ),
                        dense: true,
                        isThreeLine: false,
                        onTap: () {
                          //
                          setState(() {
                            if (openedFaq == index) {
                              openedFaq = null;
                            } else {
                              openedFaq = index;
                            }
                          });
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (ctx) => FaqDetailsPage(faq),
                          //   ),
                          // );
                        },
                      );
                    },
                    separatorBuilder: (ctx, index) => const Divider(
                      height: 1,
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
