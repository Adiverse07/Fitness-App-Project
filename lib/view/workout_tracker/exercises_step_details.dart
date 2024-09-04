import 'package:dotted_dashed_line/dotted_dashed_line.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';
import '../../common/color_extension.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class ExercisesStepDetails extends StatefulWidget {
  final Map eObj;
  final YoutubePlayerController? controller;
  final String intId;

  const ExercisesStepDetails({Key? key, required this.eObj, this.controller, required this.intId}) : super(key: key);

  @override
  State<ExercisesStepDetails> createState() => _ExercisesStepDetailsState();
}

class _ExercisesStepDetailsState extends State<ExercisesStepDetails> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? YoutubePlayerController(initialVideoId: widget.intId);
  }

  // Define separate descriptions for each exercise
  Map<String, String> exerciseDescriptions = {
    "Jumping Jack": "A jumping jack, also known as a star jump and called a side-straddle hop in the US military, is a physical jumping exercise performed by jumping to a position with the legs spread wide. A jumping jack, also known as a star jump and called a side-straddle hop in the US military, is a physical jumping exercise performed by jumping to a position with the legs spread wide. This exercise is often included in warm-up routines as it helps to increase heart rate and blood circulation throughout the body.",

    "Incline Push-Ups": "Incline push-ups are a variation of the traditional push-up exercise that target the muscles of the chest, shoulders, and arms. By elevating the hands on an elevated surface, such as a bench or a step, the exercise becomes easier to perform. Incline push-ups are an excellent way to build upper body strength and can be modified to suit individuals of all fitness levels.",

    "Knee Push-Ups": "Knee push-ups are a modified version of the traditional push-up exercise that are performed with the knees resting on the ground. This variation allows individuals to build strength in the chest, shoulders, and arms while reducing strain on the lower back and core muscles. Knee push-ups are a great option for beginners or those recovering from injury.",

    "Push-Ups": "Push-ups are a classic bodyweight exercise that target the muscles of the chest, shoulders, triceps, and core. By lifting and lowering the body using the arms, push-ups help to build upper body strength and muscular endurance. Push-ups can be modified in various ways to increase or decrease the difficulty level, making them suitable for individuals of all fitness levels.",

    "Wide Arm Push-Ups": "Wide arm push-ups are a variation of the traditional push-up exercise that target the muscles of the chest, shoulders, and arms from a wider angle. By placing the hands wider than shoulder-width apart, the exercise places more emphasis on the chest muscles. Wide arm push-ups are an effective way to strengthen the chest and can help improve overall upper body strength and definition.",

    "Squats": "Squats are a fundamental lower body exercise that target the muscles of the thighs, hips, and glutes. By bending the knees and lowering the body towards the ground, squats help to strengthen the muscles of the lower body and improve overall lower body strength and stability. Squats are a functional exercise that can benefit individuals of all fitness levels and can be performed with or without added weight.",

    "Side-Lying Leg Lift Left": "Side-lying leg lifts are a simple yet effective exercise for targeting the muscles of the outer thighs and hips. By lying on one side and lifting the top leg towards the ceiling, this exercise helps to strengthen and tone the muscles of the hips and thighs. Side-lying leg lifts can help improve hip mobility and stability and are often included in lower body strengthening routines.",

    "Backward Lunge": "Backward lunges are a variation of the traditional lunge exercise that target the muscles of the thighs, hips, and glutes. By stepping backward and lowering the body towards the ground, backward lunges help to improve balance, stability, and lower body strength. Backward lunges can be performed with bodyweight or additional resistance and are suitable for individuals of all fitness levels.",

    "Donkey Kicks Left": "Donkey kicks are a bodyweight exercise that target the muscles of the glutes and hamstrings. By kicking one leg back while in a hands and knees position, donkey kicks help to strengthen the muscles of the lower body and improve overall lower body strength and stability. Donkey kicks can be performed on their own or as part of a lower body strengthening routine.",

    "Left Quad Stretch With Wall": "The left quad stretch with wall is a simple stretch that targets the muscles of the quadriceps in the front of the thigh. By standing near a wall and bending one knee, this stretch helps to improve flexibility and range of motion in the quadriceps muscles. The left quad stretch with wall can be performed as part of a warm-up or cooldown routine to help prevent injury and improve overall lower body flexibility.",

    "Abdominal Crunches": "Abdominal crunches are a classic core exercise that target the muscles of the abdomen. By lying on the back with the knees bent and lifting the shoulders towards the ceiling, abdominal crunches help to strengthen the muscles of the core and improve overall core stability. Abdominal crunches can be performed on a mat or stability ball and can be modified to suit individuals of all fitness levels.",

    "Russian Twist": "Russian twists are a core-strengthening exercise that target the muscles of the obliques and abdominals. By sitting on the floor with the knees bent and twisting the torso from side to side, Russian twists help to improve rotational strength and stability in the core muscles. Russian twists can be performed with bodyweight or additional resistance and are an effective way to target the muscles of the core and improve overall core strength and stability.",

    "Mountain Climber": "Mountain climbers are a dynamic, full-body exercise that target the muscles of the core, shoulders, chest, and legs. By starting in a plank position and alternating driving the knees towards the chest, mountain climbers help to improve cardiovascular fitness and muscular endurance. Mountain climbers can be performed at a quick pace to increase intensity or at a slower pace for beginners or those looking to focus on form.",

    "Cobra Stretch": "The cobra stretch is a yoga-inspired stretch that targets the muscles of the chest, shoulders, and abdomen. By lying on the stomach and pressing into the hands to lift the chest towards the ceiling, the cobra stretch helps to improve flexibility and range of motion in the upper body. The cobra stretch can be performed as part of a yoga or stretching routine to help alleviate tension in the chest and shoulders and improve overall upper body flexibility.",

    "Chest Stretch": "The chest stretch is a simple stretch that targets the muscles of the chest and shoulders. By standing tall and clasping the hands behind the back, the chest stretch helps to open up the chest and shoulders and improve posture. The chest stretch can be performed throughout the day to help counteract the effects of sitting and slouching and improve overall upper body flexibility and posture.",

    "Box Push-Ups": "Box push-ups are a variation of traditional push-ups where the hands are elevated on a box or elevated surface. This modification reduces the intensity of the exercise and is suitable for beginners or those with wrist discomfort. Focus on maintaining a straight line from head to heels throughout the movement.",

    "Arm Raises": "Arm raises are a simple yet effective exercise for strengthening the shoulders and upper back. Stand with your feet shoulder-width apart and hold a light dumbbell in each hand. Slowly raise your arms straight out to the sides until they are parallel to the ground, then lower them back down with control.",

    "Side Arm Raises": "Side arm raises target the lateral deltoids, which are important for shoulder stability and aesthetics. Stand with your feet shoulder-width apart and hold a dumbbell in each hand by your sides. Keeping your arms straight, raise them out to the sides until they are parallel to the ground, then lower them back down slowly.",

    "Triceps Dips": "Triceps dips are a bodyweight exercise that primarily targets the triceps brachii muscles on the back of the arms. To perform triceps dips, sit on the edge of a sturdy chair or bench with your hands gripping the edge, fingers forward. Slide your butt off the edge and lower your body until your elbows are bent at a 90-degree angle, then push back up to the starting position.",

    "Arm Circles Clockwise": "Arm circles clockwise are a dynamic shoulder mobility exercise that helps to warm up the shoulder joints and increase blood flow to the muscles. Stand with your feet shoulder-width apart and extend your arms straight out to the sides. Begin making small circular motions with your arms, gradually increasing the size of the circles.",

    "Arm Circles CounterClockwise": "Arm circles counterclockwise are similar to arm circles clockwise but performed in the opposite direction. Stand with your feet shoulder-width apart and extend your arms straight out to the sides. Begin making small circular motions with your arms, gradually increasing the size of the circles in the counterclockwise direction.",

    "Diamond Push-Ups": "Diamond push-ups are a challenging variation of the traditional push-up that targets the triceps muscles more intensely. To perform diamond push-ups, start in a plank position with your hands close together under your chest, forming a diamond shape with your thumbs and index fingers. Lower your body towards the ground while keeping your elbows close to your sides, then push back up to the starting position.",

    "Chest Press Pulse": "Chest press pulses are a variation of the chest press exercise that adds an extra challenge by incorporating a pulsing motion at the bottom of the movement. Lie on your back on a bench or mat with a dumbbell in each hand. Start with your arms extended straight up over your chest. Lower the weights down towards your chest, then pulse them up and down slightly before pressing them back up to the starting position.",

    "Leg Barbell Curl Left": "Leg barbell curls, also known as lying leg curls, are an isolation exercise that targets the hamstrings. Lie face down on a leg curl machine with your legs straight and the pad resting just above your heels. Curl your legs up towards your glutes by bending your knees, then lower them back down with control.",

    "Leg Barbell Curl Right": "Leg barbell curls, also known as lying leg curls, are an isolation exercise that targets the hamstrings. Lie face down on a leg curl machine with your legs straight and the pad resting just above your heels. Curl your legs up towards your glutes by bending your knees, then lower them back down with control.",

    "Diagonal Plank": "Diagonal planks are a variation of the traditional plank exercise that adds a rotational component, engaging the obliques and transverse abdominis muscles. Start in a plank position with your hands under your shoulders and your body in a straight line from head to heels. Rotate your body to one side, lifting the top arm towards the ceiling while keeping your hips lifted and core engaged. Return to the starting position and repeat on the other side.",

    "Punches": "Punches are a cardiovascular exercise that also engages the muscles of the arms, shoulders, and core. Stand with your feet shoulder-width apart and fists raised in front of your face. Alternate punching forward with each arm in a quick and controlled motion, twisting your torso slightly with each punch.",

    "Inchworms": "Inchworms are a dynamic full-body stretch that targets the hamstrings, calves, shoulders, and core muscles. Start standing with your feet hip-width apart. Bend forward at the hips and place your hands on the floor in front of you. Walk your hands forward until you reach a plank position, then walk your feet towards your hands, keeping your legs straight. Continue walking your hands forward and back, moving through the stretch with control.",

    "Wall Push-Ups": "Wall push-ups are a beginner-friendly variation of the traditional push-up that can help build upper body strength. Stand facing a wall with your arms extended at shoulder height and hands flat against the wall, slightly wider than shoulder-width apart. Lean your body towards the wall, bending your elbows to lower your chest towards the wall, then push back up to the starting position.",

    "Triceps Stretch Left": "The triceps stretch targets the triceps brachii muscle on the back of the upper arm. Stand or sit upright and raise your left arm overhead. Bend your left elbow and reach your left hand down the center of your back. Use your right hand to gently push your left elbow further down, feeling a stretch along the back of your left arm. Hold the stretch for 15-30 seconds, then switch sides.",

    "Triceps Stretch Right": "The triceps stretch targets the triceps brachii muscle on the back of the upper arm. Stand or sit upright and raise your right arm overhead. Bend your right elbow and reach your right hand down the center of your back. Use your left hand to gently push your right elbow further down, feeling a stretch along the back of your right arm. Hold the stretch for 15-30 seconds, then switch sides.",

    "Standing Biceps Stretch Left": "The standing biceps stretch targets the biceps brachii muscle on the front of the upper arm. Stand upright with your feet shoulder-width apart. Extend your left arm straight out in front of you with your palm facing up. Use your right hand to gently pull back on your left fingers, feeling a stretch along the front of your left arm. Hold the stretch for 15-30 seconds, then switch sides.",

    "Standing Biceps Stretch Right": "The standing biceps stretch targets the biceps brachii muscle on the front of the upper arm. Stand upright with your feet shoulder-width apart. Extend your right arm straight out in front of you with your palm facing up. Use your left hand to gently pull back on your right fingers, feeling a stretch along the front of your right arm. Hold the stretch for 15-30 seconds, then switch sides.",

    "Rhomboid Pulls": "Rhomboid pulls are a strengthening exercise for the muscles between the shoulder blades (rhomboids) and the muscles of the mid-back. Sit or stand with your spine straight and shoulders relaxed. Squeeze your shoulder blades together, pulling them towards your spine, then release. Focus on engaging the muscles between your shoulder blades without shrugging your shoulders.",

    "Side-Lying Floor Stretch Left": "The side-lying floor stretch targets the muscles of the torso, including the obliques and quadratus lumborum. Lie on your left side with your legs straight and your left arm extended overhead. Bend your right knee and place your right foot flat on the floor behind your left leg. Reach your right arm overhead and gently stretch to the left side, feeling a stretch along the right side of your torso. Hold the stretch for 15-30 seconds, then switch sides.",

    "Side-Lying Floor Stretch Right": "The side-lying floor stretch targets the muscles of the torso, including the obliques and quadratus lumborum. Lie on your right side with your legs straight and your right arm extended overhead. Bend your left knee and place your left foot flat on the floor behind your right leg. Reach your left arm overhead and gently stretch to the right side, feeling a stretch along the left side of your torso. Hold the stretch for 15-30 seconds, then switch sides.",

    "Arm Scissors": "Arm scissors are a dynamic stretching exercise that targets the muscles of the chest, shoulders, and upper back. Stand with your feet shoulder-width apart and extend your arms straight out to the sides at shoulder height. Cross your right arm over your left arm, then open them back out to the sides. Cross your left arm over your right arm, then open them back out to the sides. Continue alternating the crossing of your arms in a scissor-like motion.",

    "Cat Cow Pose": "Cat cow pose is a yoga asana that gently stretches and mobilizes the spine, improving flexibility and relieving tension in the back and neck. Start on your hands and knees in a tabletop position. Inhale as you arch your back, dropping your belly towards the floor and lifting your head and tailbone towards the ceiling (cow pose). Exhale as you round your back, tucking your chin to your chest and drawing your belly button towards your spine (cat pose). Flow between the two poses, synchronizing your breath with your movement.",

    "Prone Triceps Push Ups": "Prone triceps push-ups are a challenging bodyweight exercise that targets the triceps muscles. Start in a face-down position on the floor with your hands flat on the ground under your shoulders. Press through your palms to straighten your arms, lifting your upper body off the ground while keeping your hips and legs in contact with the floor. Lower your body back down to the starting position, bending your elbows and keeping them close to your sides. Repeat for the prescribed number of repetitions.",

    "Reclined Rhomboid Squeezes": "Reclined rhomboid squeezes are an effective exercise for strengthening the muscles between the shoulder blades (rhomboids) and improving posture. Lie on your back with your knees bent and your feet flat on the floor. Extend your arms straight out to the sides at shoulder height, palms facing down. Squeeze your shoulder blades together, pressing them towards the floor, then release. Focus on engaging the muscles between your shoulder blades without arching your back.",

    "Child's Pose": "Child's pose is a relaxing yoga posture that stretches the muscles of the back, hips, thighs, and ankles while promoting relaxation and stress relief. Begin kneeling on the floor with your big toes touching and your knees spread apart. Sit back on your heels and hinge forward at your hips, lowering your torso towards the floor. Extend your arms out in front of you and rest your forehead on the ground. Breathe deeply and hold the pose for the prescribed duration, allowing your body to relax and sink into the stretch."

  };


  // Define separate arrays for each exercise's steps
  Map<String, List<Map<String, String>>> exerciseSteps = {
    "Jumping Jack": [
      {
        "no": "01",
        "title": "Spread Your Arms",
        "detail": "To make the gestures feel more relaxed, stretch your arms as you start this movement. No bending of hands."
      },
      {
        "no": "02",
        "title": "Rest at The Toe",
        "detail": "The basis of this movement is jumping. Now, what needs to be considered is that you have to use the tips of your feet"
      },
      {
        "no": "03",
        "title": "Adjust Foot Movement",
        "detail": "Jumping Jack is not just an ordinary jump. But, you also have to pay close attention to leg movements."
      },
      {
        "no": "04",
        "title": "Clapping Both Hands",
        "detail": "This cannot be taken lightly. You see, without realizing it, the clapping of your hands helps you to keep your rhythm while doing the Jumping Jack"
      },
    ],
    "Incline Push-Ups": [
      {
        "no": "01",
        "title": "Position Your Body",
        "detail": "Place your hands on an elevated surface, such as a bench or a step, and extend your legs behind you."
      },
      {
        "no": "02",
        "title": "Lower Your Chest",
        "detail": "Bend your elbows and lower your chest towards the surface, keeping your body straight."
      },
      {
        "no": "03",
        "title": "Push Back Up",
        "detail": "Push through your hands to return to the starting position, fully extending your arms."
      },
    ],
    "Knee Push-Ups": [
      {
        "no": "01",
        "title": "Get on Your Knees",
        "detail": "Start on your hands and knees with your hands placed slightly wider than shoulder-width apart."
      },
      {
        "no": "02",
        "title": "Lower Your Chest",
        "detail": "Bend your elbows and lower your chest towards the ground, keeping your body in a straight line."
      },
      {
        "no": "03",
        "title": "Push Back Up",
        "detail": "Push through your hands to return to the starting position, fully extending your arms."
      },
    ],
    "Push-Ups": [
      {
        "no": "01",
        "title": "Start Position",
        "detail": "Get into a plank position with your hands placed slightly wider than shoulder-width apart."
      },
      {
        "no": "02",
        "title": "Lower Your Body",
        "detail": "Bend your elbows and lower your body towards the ground until your chest almost touches the floor."
      },
      {
        "no": "03",
        "title": "Push Back Up",
        "detail": "Push through your hands to return to the starting position, fully extending your arms."
      },
    ],
    "Wide Arm Push-Ups": [
      {
        "no": "01",
        "title": "Wider Hand Placement",
        "detail": "Place your hands wider than shoulder-width apart to target different muscles."
      },
      {
        "no": "02",
        "title": "Lower Your Body",
        "detail": "Bend your elbows and lower your body towards the ground until your chest almost touches the floor."
      },
      {
        "no": "03",
        "title": "Push Back Up",
        "detail": "Push through your hands to return to the starting position, fully extending your arms."
      },
    ],
    "Squats": [
      {
        "no": "01",
        "title": "Stand Tall",
        "detail": "Stand with your feet shoulder-width apart and your toes pointing slightly outward."
      },
      {
        "no": "02",
        "title": "Lower Your Body",
        "detail": "Bend your knees and hips, lowering your body as if sitting back into a chair."
      },
      {
        "no": "03",
        "title": "Return to Starting Position",
        "detail": "Push through your heels to return to the starting position, fully extending your legs."
      },
      {
        "no": "04",
        "title": "Repeat",
        "detail": "Repeat the exercise for the desired number of repetitions."
      },
    ],
    "Side-Lying Leg Lift Left": [
      {
        "no": "01",
        "title": "Lie on Your Left Side",
        "detail": "Lie on your left side with your legs stacked on top of each other."
      },
      {
        "no": "02",
        "title": "Lift Your Leg",
        "detail": "Keeping your top leg straight, lift it towards the ceiling, then lower it back down."
      },
      {
        "no": "03",
        "title": "Switch Sides",
        "detail": "Turn onto your right side and perform the same exercise with your right leg."
      },
      {
        "no": "04",
        "title": "Repeat",
        "detail": "Repeat the exercise for the desired number of repetitions on each side."
      },
    ],
    "Backward Lunge": [
      {
        "no": "01",
        "title": "Start Position",
        "detail": "Stand tall with your feet hip-width apart and your hands on your hips."
      },
      {
        "no": "02",
        "title": "Step Back",
        "detail": "Step back with one leg, lowering your body until your back knee nearly touches the ground."
      },
      {
        "no": "03",
        "title": "Return to Starting Position",
        "detail": "Push through your front heel to return to the starting position."
      },
      {
        "no": "04",
        "title": "Repeat",
        "detail": "Repeat the exercise for the desired number of repetitions on each leg."
      },
    ],
    "Donkey Kicks Left": [
      {
        "no": "01",
        "title": "Start on Hands and Knees",
        "detail": "Start on your hands and knees with your wrists under your shoulders and your knees under your hips."
      },
      {
        "no": "02",
        "title": "Kick Back",
        "detail": "Keeping your knee bent, lift one leg and push your foot towards the ceiling."
      },
      {
        "no": "03",
        "title": "Lower Your Leg",
        "detail": "Lower your leg back down to the starting position."
      },
      {
        "no": "04",
        "title": "Repeat",
        "detail": "Repeat the exercise for the desired number of repetitions on each leg."
      },
    ],
    "Left Quad Stretch With Wall": [
      {
        "no": "01",
        "title": "Stand Near a Wall",
        "detail": "Stand facing a wall and place one hand on the wall for support."
      },
      {
        "no": "02",
        "title": "Bend Your Knee",
        "detail": "Bend one knee and grab the corresponding ankle with the hand on the same side."
      },
      {
        "no": "03",
        "title": "Hold the Stretch",
        "detail": "Hold the stretch for the desired amount of time, then switch sides."
      },
      {
        "no": "04",
        "title": "Repeat",
        "detail": "Repeat the stretch for the desired number of repetitions on each side."
      },
    ],
    "Abdominal Crunches": [
      {
        "no": "01",
        "title": "Lie on Your Back",
        "detail": "Lie on your back with your knees bent and your feet flat on the floor."
      },
      {
        "no": "02",
        "title": "Cross Your Arms",
        "detail": "Cross your arms over your chest or place your hands behind your head."
      },
      {
        "no": "03",
        "title": "Lift Your Shoulders",
        "detail": "Engage your core muscles and lift your shoulders towards the ceiling, keeping your lower back pressed into the floor."
      },
      {
        "no": "04",
        "title": "Lower Your Upper Body",
        "detail": "Slowly lower your upper body back down to the starting position."
      },
    ],
    "Russian Twist": [
      {
        "no": "01",
        "title": "Sit on the Floor",
        "detail": "Sit on the floor with your knees bent and your feet flat on the ground."
      },
      {
        "no": "02",
        "title": "Lean Backward",
        "detail": "Lean backward slightly, engaging your core muscles to stabilize your spine."
      },
      {
        "no": "03",
        "title": "Twist Your Torso",
        "detail": "Twist your torso to one side, bringing your hands or a weight towards the floor beside you."
      },
      {
        "no": "04",
        "title": "Switch Sides",
        "detail": "Twist your torso to the other side, bringing your hands or weight towards the floor beside you."
      },
    ],
    "Mountain Climber": [
      {
        "no": "01",
        "title": "Start in Plank Position",
        "detail": "Begin in a plank position with your hands directly under your shoulders and your body in a straight line."
      },
      {
        "no": "02",
        "title": "Drive Your Knees",
        "detail": "Drive one knee towards your chest, then quickly switch legs, keeping your hips level and your core engaged."
      },
      {
        "no": "03",
        "title": "Alternate Legs",
        "detail": "Continue alternating legs at a quick pace, as if you're running in place."
      },
      {
        "no": "04",
        "title": "Maintain Form",
        "detail": "Focus on maintaining proper plank form throughout the exercise."
      },
    ],
    "Cobra Stretch": [
      {
        "no": "01",
        "title": "Lie on Your Stomach",
        "detail": "Lie on your stomach with your palms on the floor under your shoulders."
      },
      {
        "no": "02",
        "title": "Lift Your Chest",
        "detail": "Press into your palms to lift your chest off the floor, keeping your hips grounded."
      },
      {
        "no": "03",
        "title": "Lengthen Your Spine",
        "detail": "Lengthen your spine as you lift your chest, feeling a gentle stretch in your abdomen and low back."
      },
      {
        "no": "04",
        "title": "Hold and Release",
        "detail": "Hold the stretch for a few breaths, then release back to the starting position."
      },
    ],
    "Chest Stretch": [
      {
        "no": "01",
        "title": "Stand Tall",
        "detail": "Stand tall with your feet hip-width apart and your arms relaxed at your sides."
      },
      {
        "no": "02",
        "title": "Clasp Your Hands",
        "detail": "Clasp your hands behind your back, straightening your arms and lifting your chest."
      },
      {
        "no": "03",
        "title": "Open Your Chest",
        "detail": "Gently squeeze your shoulder blades together as you open your chest and lift your gaze."
      },
      {
        "no": "04",
        "title": "Hold and Release",
        "detail": "Hold the stretch for a few breaths, then release and shake out your arms."
      },
    ],
    "Box Push-Ups": [
      {
        "no": "01",
        "title": "Position Your Hands",
        "detail": "Start by placing your hands shoulder-width apart on the floor, fingers pointing forward."
      },
      {
        "no": "02",
        "title": "Lower Your Body",
        "detail": "Lower your chest towards the floor by bending your elbows, keeping your back straight."
      },
      {
        "no": "03",
        "title": "Push Back Up",
        "detail": "Push through your palms to raise your body back up to the starting position."
      },
      {
        "no": "04",
        "title": "Repeat",
        "detail": "Repeat the movement for the prescribed number of repetitions."
      }
    ],
    "Arm Raises": [
      {
        "no": "01",
        "title": "Start Position",
        "detail": "Stand tall with your feet shoulder-width apart and arms at your sides."
      },
      {
        "no": "02",
        "title": "Raise Arms",
        "detail": "Keeping your arms straight, lift them out to the sides until they reach shoulder height."
      },
      {
        "no": "03",
        "title": "Lower Arms",
        "detail": "Slowly lower your arms back to the starting position."
      },
      {
        "no": "04",
        "title": "Repeat",
        "detail": "Repeat the movement for the prescribed duration."
      }
    ],
    "Side Arm Raises": [
      {
        "no": "01",
        "title": "Initial Position",
        "detail": "Stand with your feet shoulder-width apart, arms at your sides."
      },
      {
        "no": "02",
        "title": "Lift Arms Sideways",
        "detail": "Raise your arms straight out to the sides until they are parallel to the floor."
      },
      {
        "no": "03",
        "title": "Lower Arms",
        "detail": "Slowly lower your arms back to the starting position."
      },
      {
        "no": "04",
        "title": "Repeat",
        "detail": "Repeat the movement for the prescribed duration."
      }
    ],
    "Triceps Dips": [
      {
        "no": "01",
        "title": "Position Yourself",
        "detail": "Sit on the edge of a chair or bench with your hands gripping the edge, fingers facing forward."
      },
      {
        "no": "02",
        "title": "Lower Your Body",
        "detail": "Slide your butt off the edge of the chair, lowering your body towards the floor."
      },
      {
        "no": "03",
        "title": "Push Back Up",
        "detail": "Push through your palms to raise your body back up to the starting position."
      },
      {
        "no": "04",
        "title": "Repeat",
        "detail": "Repeat the movement for the prescribed number of repetitions."
      }
    ],
    "Arm Circles Clockwise": [
      {
        "no": "01",
        "title": "Stand Tall",
        "detail": "Stand with your feet shoulder-width apart and extend your arms straight out to the sides."
      },
      {
        "no": "02",
        "title": "Make Small Circles",
        "detail": "Begin making small circles with your arms, moving them in a clockwise direction."
      },
      {
        "no": "03",
        "title": "Maintain Control",
        "detail": "Keep your core engaged and maintain control throughout the movement."
      },
      {
        "no": "04",
        "title": "Reverse Direction",
        "detail": "After the prescribed duration, reverse the direction of the circles."
      }
    ],
    "Arm Circles CounterClockwise": [
      {
        "no": "01",
        "title": "Stand Tall",
        "detail": "Stand with your feet shoulder-width apart and extend your arms straight out to the sides."
      },
      {
        "no": "02",
        "title": "Make Small Circles",
        "detail": "Begin making small circles with your arms, moving them in a counterclockwise direction."
      },
      {
        "no": "03",
        "title": "Maintain Control",
        "detail": "Keep your core engaged and maintain control throughout the movement."
      },
      {
        "no": "04",
        "title": "Reverse Direction",
        "detail": "After the prescribed duration, reverse the direction of the circles."
      }
    ],

    "Diamond Push-Ups": [
      {
        "no": "01",
        "title": "Get into Position",
        "detail": "Assume a push-up position with your hands close together under your chest, forming a diamond shape with your thumbs and index fingers."
      },
      {
        "no": "02",
        "title": "Lower Your Body",
        "detail": "Lower your chest towards the diamond shape formed by your hands, keeping your elbows close to your body."
      },
      {
        "no": "03",
        "title": "Push Back Up",
        "detail": "Push through your palms to raise your body back up to the starting position."
      },
      {
        "no": "04",
        "title": "Repeat",
        "detail": "Repeat the movement for the prescribed number of repetitions."
      }
    ],
    "Chest Press Pulse": [
      {
        "no": "01",
        "title": "Lie Down",
        "detail": "Lie on your back on a bench or the floor with a dumbbell in each hand, palms facing forward."
      },
      {
        "no": "02",
        "title": "Press the Weights",
        "detail": "Press the weights up towards the ceiling until your arms are fully extended."
      },
      {
        "no": "03",
        "title": "Pulse",
        "detail": "With a slight bend in your elbows, pulse the weights up and down in a small range of motion."
      },
      {
        "no": "04",
        "title": "Repeat",
        "detail": "Repeat the pulsing motion for the prescribed duration."
      }
    ],
    "Leg Barbell Curl Left": [
      {
        "no": "01",
        "title": "Prepare the Equipment",
        "detail": "Place a barbell on the ground and stand behind it with your feet shoulder-width apart."
      },
      {
        "no": "02",
        "title": "Grab the Bar",
        "detail": "Bend at the waist and grab the barbell with an overhand grip, hands shoulder-width apart."
      },
      {
        "no": "03",
        "title": "Curl the Bar",
        "detail": "Keeping your upper arms stationary, curl the barbell up towards your chest by bending your elbows."
      },
      {
        "no": "04",
        "title": "Lower the Bar",
        "detail": "Slowly lower the barbell back to the starting position, fully extending your arms."
      }
    ],
    "Leg Barbell Curl Right": [
      {
        "no": "01",
        "title": "Prepare the Equipment",
        "detail": "Place a barbell on the ground and stand behind it with your feet shoulder-width apart."
      },
      {
        "no": "02",
        "title": "Grab the Bar",
        "detail": "Bend at the waist and grab the barbell with an overhand grip, hands shoulder-width apart."
      },
      {
        "no": "03",
        "title": "Curl the Bar",
        "detail": "Keeping your upper arms stationary, curl the barbell up towards your chest by bending your elbows."
      },
      {
        "no": "04",
        "title": "Lower the Bar",
        "detail": "Slowly lower the barbell back to the starting position, fully extending your arms."
      }
    ],
    "Diagonal Plank": [
      {
        "no": "01",
        "title": "Start in Plank Position",
        "detail": "Begin in a traditional plank position with your forearms on the ground, elbows directly beneath your shoulders."
      },
      {
        "no": "02",
        "title": "Lift One Arm",
        "detail": "Lift one arm off the ground and extend it straight out in front of you at a diagonal angle."
      },
      {
        "no": "03",
        "title": "Hold",
        "detail": "Hold this position for the prescribed duration, keeping your core engaged and hips stable."
      },
      {
        "no": "04",
        "title": "Switch Sides",
        "detail": "After completing one side, switch to the other arm and repeat the movement."
      }
    ],
    "Punches": [
      {
        "no": "01",
        "title": "Get into Position",
        "detail": "Stand with your feet shoulder-width apart and knees slightly bent, fists raised in front of your face."
      },
      {
        "no": "02",
        "title": "Punch Forward",
        "detail": "Extend your left arm straight out in front of you, then quickly pull it back as you extend your right arm."
      },
      {
        "no": "03",
        "title": "Keep Moving",
        "detail": "Continue alternating punches with speed and control for the prescribed duration."
      },
      {
        "no": "04",
        "title": "Maintain Form",
        "detail": "Focus on keeping your core engaged and rotating your torso with each punch."
      }
    ],
    "Inchworms": [
      {
        "no": "01",
        "title": "Start Standing",
        "detail": "Stand tall with your feet hip-width apart and arms at your sides."
      },
      {
        "no": "02",
        "title": "Bend at the Hips",
        "detail": "Bend at the hips and reach your hands towards the floor, keeping your legs as straight as possible."
      },
      {
        "no": "03",
        "title": "Walk Out",
        "detail": "Walk your hands forward until you reach a plank position, keeping your core engaged."
      },
      {
        "no": "04",
        "title": "Walk Back",
        "detail": "Walk your hands back towards your feet, keeping your legs straight, until you return to the starting position."
      }
    ],

    "Wall Push-Ups": [
      {
        "no": "01",
        "title": "Position Yourself",
        "detail": "Stand facing a wall with your arms extended at shoulder height and hands flat against the wall, slightly wider than shoulder-width apart."
      },
      {
        "no": "02",
        "title": "Lower Your Body",
        "detail": "Bend your elbows and lean your body towards the wall until your nose nearly touches it, keeping your body straight from head to heels."
      },
      {
        "no": "03",
        "title": "Push Back Up",
        "detail": "Push through your palms to straighten your arms and return to the starting position."
      },
      {
        "no": "04",
        "title": "Repeat",
        "detail": "Repeat the movement for the prescribed number of repetitions."
      }
    ],
    "Triceps Stretch Left": [
      {
        "no": "01",
        "title": "Arm Position",
        "detail": "Raise your left arm overhead and bend it, bringing your left hand down towards the center of your back."
      },
      {
        "no": "02",
        "title": "Stretch",
        "detail": "Use your right hand to gently press down on your left elbow, increasing the stretch in your triceps."
      },
      {
        "no": "03",
        "title": "Hold",
        "detail": "Hold the stretch for the prescribed duration, feeling a gentle pull along the back of your left arm."
      },
      {
        "no": "04",
        "title": "Switch Sides",
        "detail": "After completing the stretch on one side, switch arms and repeat the movement with your right arm."
      }
    ],
    "Triceps Stretch Right": [
      {
        "no": "01",
        "title": "Arm Position",
        "detail": "Raise your right arm overhead and bend it, bringing your right hand down towards the center of your back."
      },
      {
        "no": "02",
        "title": "Stretch",
        "detail": "Use your left hand to gently press down on your right elbow, increasing the stretch in your triceps."
      },
      {
        "no": "03",
        "title": "Hold",
        "detail": "Hold the stretch for the prescribed duration, feeling a gentle pull along the back of your right arm."
      },
      {
        "no": "04",
        "title": "Switch Sides",
        "detail": "After completing the stretch on one side, switch arms and repeat the movement with your left arm."
      }
    ],
    "Standing Biceps Stretch Left": [
      {
        "no": "01",
        "title": "Arm Position",
        "detail": "Extend your left arm straight in front of you with your palm facing up."
      },
      {
        "no": "02",
        "title": "Pull Back Fingers",
        "detail": "Use your right hand to gently pull back the fingers of your left hand, stretching the biceps."
      },
      {
        "no": "03",
        "title": "Hold",
        "detail": "Hold the stretch for the prescribed duration, feeling a gentle pull along the front of your left arm."
      },
      {
        "no": "04",
        "title": "Switch Sides",
        "detail": "After completing the stretch on one side, switch arms and repeat the movement with your right arm."
      }
    ],
    "Standing Biceps Stretch Right": [
      {
        "no": "01",
        "title": "Arm Position",
        "detail": "Extend your right arm straight in front of you with your palm facing up."
      },
      {
        "no": "02",
        "title": "Pull Back Fingers",
        "detail": "Use your left hand to gently pull back the fingers of your right hand, stretching the biceps."
      },
      {
        "no": "03",
        "title": "Hold",
        "detail": "Hold the stretch for the prescribed duration, feeling a gentle pull along the front of your right arm."
      },
      {
        "no": "04",
        "title": "Switch Sides",
        "detail": "After completing the stretch on one side, switch arms and repeat the movement with your left arm."
      }
    ],
    "Rhomboid Pulls": [
      {
        "no": "01",
        "title": "Starting Position",
        "detail": "Sit upright on a chair with your feet flat on the floor and your spine straight."
      },
      {
        "no": "02",
        "title": "Pull Shoulder Blades",
        "detail": "Slowly squeeze your shoulder blades together, pulling them towards your spine."
      },
      {
        "no": "03",
        "title": "Hold",
        "detail": "Hold the contraction for a brief moment, focusing on engaging the muscles between your shoulder blades."
      },
      {
        "no": "04",
        "title": "Release",
        "detail": "Slowly release the contraction and return to the starting position."
      }
    ],
    "Side-Lying Floor Stretch Left": [
      {
        "no": "01",
        "title": "Lie on Your Side",
        "detail": "Lie on your left side with your legs straight and your left arm extended to support your head."
      },
      {
        "no": "02",
        "title": "Reach Overhead",
        "detail": "Reach your right arm overhead and grasp your left wrist, gently pulling to stretch the left side of your body."
      },
      {
        "no": "03",
        "title": "Hold",
        "detail": "Hold the stretch for the prescribed duration, feeling a gentle pull along the left side of your torso."
      },
      {
        "no": "04",
        "title": "Switch Sides",
        "detail": "After completing the stretch on your left side, switch to your right side and repeat the movement."
      }
    ],
    "Side-Lying Floor Stretch Right": [
      {
        "no": "01",
        "title": "Lie on Your Side",
        "detail": "Lie on your right side with your legs straight and your right arm extended to support your head."
      },
      {
        "no": "02",
        "title": "Reach Overhead",
        "detail": "Reach your left arm overhead and grasp your right wrist, gently pulling to stretch the right side of your body."
      },
      {
        "no": "03",
        "title": "Hold",
        "detail": "Hold the stretch for the prescribed duration, feeling a gentle pull along the right side of your torso."
      },
      {
        "no": "04",
        "title": "Switch Sides",
        "detail": "After completing the stretch on your right side, switch to your left side and repeat the movement."
      }
    ],
    "Arm Scissors": [
      {
        "no": "01",
        "title": "Starting Position",
        "detail": "Stand with your feet shoulder-width apart and extend your arms straight out to the sides at shoulder height."
      },
      {
        "no": "02",
        "title": "Cross Arms",
        "detail": "Cross your right arm over your left arm, crossing at the elbows, and then return to the starting position."
      },
      {
        "no": "03",
        "title": "Cross Arms",
        "detail": "Cross your left arm over your right arm, crossing at the elbows, and then return to the starting position."
      },
      {
        "no": "04",
        "title": "Repeat",
        "detail": "Continue alternating the crossing of your arms for the prescribed duration, maintaining a steady pace."
      }
    ],
    "Cat Cow Pose": [
      {
        "no": "01",
        "title": "Starting Position",
        "detail": "Start on your hands and knees in a tabletop position, with your wrists aligned under your shoulders and your knees under your hips."
      },
      {
        "no": "02",
        "title": "Cow Pose",
        "detail": "Inhale as you arch your back, dropping your belly towards the floor and lifting your head and tailbone towards the ceiling."
      },
      {
        "no": "03",
        "title": "Cat Pose",
        "detail": "Exhale as you round your back, tucking your chin to your chest and drawing your belly button towards your spine."
      },
      {
        "no": "04",
        "title": "Repeat",
        "detail": "Continue flowing between Cat Pose and Cow Pose, synchronizing your breath with your movement."
      }
    ],
    "Prone Triceps Push Ups": [
      {
        "no": "01",
        "title": "Starting Position",
        "detail": "Lie face down on the floor with your hands flat on the ground, positioned directly under your shoulders."
      },
      {
        "no": "02",
        "title": "Push Up",
        "detail": "Press through your palms to straighten your arms, lifting your upper body off the ground while keeping your hips and legs in contact with the floor."
      },
      {
        "no": "03",
        "title": "Lower",
        "detail": "Lower your body back down to the starting position, bending your elbows and keeping them close to your sides."
      },
      {
        "no": "04",
        "title": "Repeat",
        "detail": "Repeat the movement for the prescribed number of repetitions, maintaining proper form throughout."
      }
    ],
    "Reclined Rhomboid Squeezes": [
      {
        "no": "01",
        "title": "Starting Position",
        "detail": "Lie on your back with your knees bent and your feet flat on the floor, hip-width apart."
      },
      {
        "no": "02",
        "title": "Arm Position",
        "detail": "Extend your arms straight out to the sides at shoulder height, palms facing down."
      },
      {
        "no": "03",
        "title": "Squeeze Shoulder Blades",
        "detail": "Engage your rhomboid muscles to squeeze your shoulder blades together, pressing them towards the floor."
      },
      {
        "no": "04",
        "title": "Release",
        "detail": "Relax your shoulder blades back to the starting position and repeat the movement for the prescribed number of repetitions."
      }
    ],
    "Child's Pose": [
      {
        "no": "01",
        "title": "Starting Position",
        "detail": "Kneel on the floor with your big toes touching and your knees spread apart, hip-width or wider."
      },
      {
        "no": "02",
        "title": "Fold Forward",
        "detail": "Hinge at your hips and fold your torso forward, reaching your arms out in front of you and lowering your forehead towards the floor."
      },
      {
        "no": "03",
        "title": "Relax",
        "detail": "Relax into the stretch, allowing your spine to lengthen and your hips to sink towards your heels."
      },
      {
        "no": "04",
        "title": "Hold",
        "detail": "Hold the pose for the prescribed duration, focusing on deep breaths and releasing tension."
      }
    ],
    // Add more exercises and their steps as needed
  };


  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    // Retrieve the description for the selected exercise
    String description = exerciseDescriptions[widget.eObj["title"]] ?? "";

    // Retrieve the steps for the selected exercise
    List<Map<String, String>> selectedExerciseSteps = exerciseSteps[widget.eObj["title"]] ?? [];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Tcolor.white,
        centerTitle: true,
        elevation: 0,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            margin: const EdgeInsets.all(8),
            height: 40,
            width: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: Tcolor.lightgray,
                borderRadius: BorderRadius.circular(10)),
            child: Image.asset(
              "assets/images/closed_btn.png",
              width: 15,
              height: 15,
              fit: BoxFit.contain,
            ),
          ),
        ),
        // actions: [
        //   Container(
        //     margin: const EdgeInsets.all(10),
        //     child: Material(
        //       borderRadius: BorderRadius.circular(10),
        //       clipBehavior: Clip.antiAliasWithSaveLayer,
        //       child: InkWell(
        //         onTap: () {},
        //         child: Ink.image(
        //           image: AssetImage("assets/images/Notification.png"),
        //           height: 40,
        //           width: 40,
        //           fit: BoxFit.fitHeight,
        //         ),
        //       ),
        //     ),
        //   ),
        // ],
      ),
      backgroundColor: Tcolor.white,
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: media.width,
                    height: media.width * 0.43,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(colors: Tcolor.primaryG),
                        borderRadius: BorderRadius.circular(20)),
                    child: YoutubePlayer(controller: _controller),
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                widget.eObj["title"].toString(),
                style: TextStyle(
                    color: Tcolor.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w700),
              ),
              const SizedBox(
                height: 3,
              ),

              const SizedBox(
                height: 15,
              ),
              Text(
                "Descriptions",
                style: TextStyle(
                    color: Tcolor.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w700),
              ),
              const SizedBox(
                height: 2,
              ),
              ReadMoreText(
                description, // Retrieve the description for the selected exercise
                trimLines: 4,
                colorClickableText: Tcolor.black,
                trimMode: TrimMode.Line,
                trimCollapsedText: ' Read More ...',
                trimExpandedText: ' Read Less',
                style: TextStyle(
                  color: Tcolor.gray,
                  fontSize: 12,
                ),
                moreStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "How To Do It",
                    style: TextStyle(
                        color: Tcolor.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w700),
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: selectedExerciseSteps.length,
                itemBuilder: ((context, index) {
                  var sObj = selectedExerciseSteps[index];

                  return StepDetailRow(
                    sObj: sObj,
                    isLast: selectedExerciseSteps.last == sObj,
                  );
                }),
              ),
              const SizedBox(
                height: 15,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StepDetailRow extends StatelessWidget {
  final Map<String, String> sObj;
  final bool isLast;

  const StepDetailRow({Key? key, required this.sObj, this.isLast = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 25,
          child: Text(
            sObj["no"].toString(),
            style: TextStyle(
              color: Tcolor.secondaryColor1,
              fontSize: 14,
            ),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: Tcolor.secondaryColor1,
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.center,
              child: Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  border: Border.all(color: Tcolor.white, width: 3),
                  borderRadius: BorderRadius.circular(9),
                ),
              ),
            ),
            if (!isLast)
              DottedDashedLine(
                height: 80,
                width: 0,
                dashColor: Tcolor.secondaryColor1,
                axis: Axis.vertical,
              )
          ],
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                sObj["title"].toString(),
                style: TextStyle(
                  color: Tcolor.black,
                  fontSize: 14,
                ),
              ),
              Text(
                sObj["detail"].toString(),
                style: TextStyle(color: Tcolor.gray, fontSize: 12),
              ),
            ],
          ),
        )
      ],
    );
  }
}
