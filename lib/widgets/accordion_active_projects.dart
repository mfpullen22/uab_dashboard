import "package:accordion/accordion.dart";
import "package:flutter/material.dart";
import "package:simple_rich_text/simple_rich_text.dart";

class AccordionActiveProjects extends StatelessWidget {
  const AccordionActiveProjects({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Accordion(
        children: [
          AccordionSection(
            header: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Prospective Nationwide Study of Endemic Mycoses",
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(fontSize: 24.0, color: Colors.white),
              ),
            ),
            content: SizedBox(
              width: MediaQuery.of(context).size.width * 0.4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SimpleRichText("*_Principal Investigator_*: Matthew Pullen"),
                  SimpleRichText("*_Start Date_*: 09\\/01\\/2024"),
                  SimpleRichText("*_End Date_*: TBD"),
                  SimpleRichText("*_Status_*: Active"),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
