import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_forge2d/body_component.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../games/UghGame.dart';

class EmberPlayer2 extends SpriteAnimationComponent
    with HasGameRef<UghGame> {

  late int iTipo=-1;

  EmberPlayer2({
    required super.position,required this.iTipo
    ,required super.size
  }) : super( anchor: Anchor.center);

  @override
  void onLoad() {
    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache('ember.png'),
      SpriteAnimationData.sequenced(
        amount: 4,
        amountPerRow: 4,
        textureSize: Vector2(16,16),
        stepTime: 0.12,
      ),
    );

  }
}

class EmberPlayerBody2 extends BodyComponent with KeyboardHandler{
  final Vector2 velocidad = Vector2.zero();
  final double aceleracion = 200;
  final Set<LogicalKeyboardKey> magiaSubZero={LogicalKeyboardKey.arrowDown, LogicalKeyboardKey.keyA};
  final Set<LogicalKeyboardKey> magiaScorpio={LogicalKeyboardKey.arrowUp, LogicalKeyboardKey.keyK};
  late int iTipo=-1;
  late Vector2 tamano;
  int horizontalDirection = 0;
  int verticalDirection = 0;
  static const  int I_PLAYER_SUBZERO=0;
  static const  int I_PLAYER_SCORPIO=1;
  static const  int I_PLAYER_TANYA=2;
  final _defaultColor = Colors.red;
  late EmberPlayer2 emberPlayer2;
  late double jumpSpeed=0.0;
  late ShapeHitbox hitbox;

  EmberPlayerBody2({Vector2? initialPosition,required this.iTipo,
    required this.tamano})
      : super(
    fixtureDefs: [
      FixtureDef(
        CircleShape()..radius = tamano.x/2,
        restitution: 0.8,
        friction: 0.4,
      ),
    ],
    bodyDef: BodyDef(
      angularDamping: 0.8,
      position: initialPosition ?? Vector2.zero(),
      type: BodyType.dynamic,
    ),
  );


  @override
  Future<void> onLoad() {
    // TODO: implement onLoad
    emberPlayer2=EmberPlayer2(position: Vector2(0,0),iTipo: iTipo,size:tamano);
    add(emberPlayer2);
    return super.onLoad();
  }

  @override
  void onTapDown(_) {
    body.applyLinearImpulse(Vector2.random() * 5000);
  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    // TODO: implement onKeyEvent
    //print("TECLADO PRESIONADO: "+event.data.logicalKey.keyId.toString());
    /*if(keysPressed.contains(LogicalKeyboardKey.arrowRight)){
      position.x+=20;
    }
    else if(keysPressed.contains(LogicalKeyboardKey.arrowLeft)){
      position.x-=20;
    }
    else if(keysPressed.contains(LogicalKeyboardKey.arrowUp)){
      position.y-=20;
    }
    else if(keysPressed.contains(LogicalKeyboardKey.arrowDown)){
      position.y+=20;
    }*/
    horizontalDirection = 0;
    verticalDirection = 0;

    if(keysPressed.contains(LogicalKeyboardKey.arrowLeft)){
      horizontalDirection=-1;
    }
    else if(keysPressed.contains(LogicalKeyboardKey.arrowRight)){
      horizontalDirection=1;
    }


    if(keysPressed.contains(LogicalKeyboardKey.arrowUp)){
      verticalDirection=-1;
    }
    else if(keysPressed.contains(LogicalKeyboardKey.arrowDown)){
      verticalDirection=1;
    }

    return true;
  }

  @override
  void update(double dt) {
    // TODO: implement update
    /*velocidad.x = horizontalDirection * aceleracion; //v=a*t
    velocidad.y = verticalDirection * aceleracion; //v=a*t
    //position += velocidad * dt; //d=v*t

    position.x += velocidad.x * dt; //d=v*t
    position.y += velocidad.y * dt; //d=v*t*/

    velocidad.x = horizontalDirection * aceleracion;
    velocidad.y = verticalDirection * aceleracion;
    velocidad.y += -1 * jumpSpeed;

    print("--------->>>>>>>>> ${velocidad}");
    //game.mapComponent.position -= velocity * dt;

    /**
     * IMPORTANTE! Para mover el personaje debemos APLICAR FUERZAS al CUERPO
     * NO mover las coordenadas usando el center ya que luego cuando el objeto REPOSA en el suelo,
     * este pasa a modo "dormido" y para despertarle DEBEMOS usar FUERZAS y no tocar el center.
     * Ver documentacion sobre BOX2D (https://www.iforce2d.net/b2dtut/forces)
     */
    //center.add((velocity * dt));
    body.applyLinearImpulse(velocidad*dt*1000);
    //body.applyAngularImpulse(3);

    if (horizontalDirection < 0 && emberPlayer2.scale.x > 0) {
      //flipAxisDirection(AxisDirection.left);
      //flipAxis(Axis.horizontal);
      emberPlayer2.flipHorizontallyAroundCenter();
    } else if (horizontalDirection > 0 && emberPlayer2.scale.x < 0) {
      //flipAxisDirection(AxisDirection.left);
      emberPlayer2.flipHorizontallyAroundCenter();
    }



    super.update(dt);
  }

}