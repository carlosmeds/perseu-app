import 'package:flutter/material.dart';
import 'package:perseu/src/components/session_data/session_data.dart';
import 'package:perseu/src/models/exercise_model.dart';
import 'package:perseu/src/models/sessions_model.dart';
import 'package:perseu/src/models/training_model.dart';
import 'package:perseu/src/viewModels/training_list_view_model.dart';

class TrainingSessionList extends StatefulWidget {
  const TrainingSessionList({Key? key, required this.training})
      : super(key: key);
  final TrainingModel training;

  @override
  TrainingSessionListState createState() => TrainingSessionListState();
}

class TrainingSessionListState extends State<TrainingSessionList> {
  late final TrainingModel training = widget.training;
  late final List<TrainingCard> _data = generateItems(training.sessions);

  final List<ExerciseItem> items = generateExercises([
    ExerciseModel(id: 1, name: 'exercício top', description: 'descrição top'),
    ExerciseModel(
        id: 1, name: 'exercício top 2', description: 'mais cansado nessa')
  ]);

  @override
  Widget build(BuildContext context) {
    print(training.sessions[0].exercises[0].description);
    return ExpansionPanelList(
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          _data[index].isExpanded = !isExpanded;
        });
      },
      children: _data.map<ExpansionPanel>((TrainingCard item) {
        return ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
              title: Text(item.headerValue),
            );
          },
          body: ListView(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              children: [
                ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];

                    return ListTile(
                      title: item.buildTitle(context),
                      subtitle: item.buildSubtitle(context),
                    );
                  },
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const IconButton(onPressed: null, icon: Icon(Icons.edit)),
                    IconButton(
                        onPressed: () {
                          setState(() {
                            _data.removeWhere(
                                (currentItem) => item == currentItem);
                          });
                        },
                        icon: const Icon(Icons.delete)),
                  ],
                ),
              ]),
          isExpanded: item.isExpanded,
        );
      }).toList(),
    );
  }
}

List<TrainingCard> generateItems(List<SessionModel> sessions) {
  return List.generate(sessions.length, (index) {
    return TrainingCard(
      headerValue: sessions[index].name,
      expandedValue: 'Exercicios $index',
      isExpanded: false,
    );
  });
}

List<ExerciseItem> generateExercises(List<ExerciseModel> exerciseList) {
  return List<ExerciseItem>.generate(
    exerciseList.length,
    (i) => Exercise(exerciseList[i].name, exerciseList[i].description),
  );
}
