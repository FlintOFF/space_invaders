# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).

radar_frame = FrameService.load_from_file(Rails.root.join('test', 'fixtures', 'files', 'radar_1.txt'))
radar_frame_info = FrameService.info(radar_frame)

admin = User.create(email: 'smstur@gmail.com', password: 'super_password', admin: true)

radar_1 = Radar.create({ title: 'Flycatcher (KL/MSS-6720)', description: 'The Flycatcher (KL/MSS-6720) radarsystem is a dual I/J/K-Band short range air defense fire control system. It has an all-weather capability and track-while-scan capability and can simultaneously control three anti-aircraft guns or SAM rocket launchers. The radar system used in the Flycatcher is identical to the system used in the PRTL/Cheetah, the Dutch version of the self-propelled anti-aircraft gun Gepard. The Goalkeeper CIWS uses a similar radar system.' }.merge(radar_frame_info))

Target.create(
  radar: radar_1,
  kind: :enemy,
  title: 'Jabba the Hutt',
  description: 'Jabba the Hutt was one of the galaxy\'s most powerful gangsters, with far-reaching influence in both politics and the criminal underworld.',
  frame:  FrameService.load_from_file(Rails.root.join('test', 'fixtures', 'files', 'radar_1_target_1.txt'))
)

Target.create(
  radar: radar_1,
  kind: :enemy,
  title: 'Darth Vader',
  description: 'Once a heroic Jedi Knight, Darth Vader was seduced by the dark side of the Force, became a Sith Lord, and led the Empire’s eradication of the Jedi Order.',
  frame: FrameService.load_from_file(Rails.root.join('test', 'fixtures', 'files', 'radar_1_target_2.txt'))
)

Task.create(
  radar: radar_1,
  user: admin,
  frame: radar_frame
)