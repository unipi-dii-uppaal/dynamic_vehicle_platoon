//Pr[<=300] ([] positions[0] > positions[1] + 4)
//Pr[<=300] ([] positions[1] > positions[2] + 4)
//Pr[<=300] ([] positions[2] > positions[3] + 4)

//Pr[<=200] (<>Follower1.joined)
//Pr[<=200] (<>Follower2.joined)
//Pr[<=200] (<>Follower3.joined)

// Pr[<=300] ([] (not Follower1.LEFT) imply positions[0] > positions[1] + 4)
// Pr[<=300] ([] (not Follower2.LEFT) imply positions[Follower2.next] > positions[Follower2.i] + 4)
// Pr[<=300] ([] (not Follower3.LEFT) imply positions[Follower3.next] > positions[Follower3.i] + 4)

//Pr[<=200] (<> 1.0*t >= 100 && (Sim.distances[0] > desired_distance*0.95 && Sim.distances[0] < desired_distance*1.05))
//Pr[<=200] (<> 1.0*t >= 100 && (Sim.distances[1] > desired_distance*0.95 && Sim.distances[1] < desired_distance*1.05))
//Pr[<=200] (<> 1.0*t >= 100 && (Sim.distances[2] > desired_distance*0.95 && Sim.distances[2] < desired_distance*1.05))

//Pr[<=200] ([] 1.0*t>= 100 imply (Sim.distances[0] > desired_distance*0.95 && Sim.distances[0] < desired_distance*1.05))
//Pr[<=200] ([] 1.0*t>= 100 imply (Sim.distances[1] > desired_distance*0.95 && Sim.distances[1] < desired_distance*1.05))
//Pr[<=200] ([] 1.0*t>= 100 imply (Sim.distances[2] > desired_distance*0.95 && Sim.distances[2] < desired_distance*1.05))

//Pr[<=300] (<> t>= 100 && (Sim.distances[1] > desired_distance*0.90 && Sim.distances[1] < desired_distance*1.10))
//Pr[<=300] (<> t>= 100 && (Sim.distances[1] > desired_distance*0.90 && Sim.distances[1] < desired_distance*1.10))
//Pr[<=300] (<> t>= 100 && (Sim.distances[2] > desired_distance*0.90 && Sim.distances[2] < desired_distance*1.10))

//Pr[<=300] ([] 1.0*t>= 100 imply (Sim.distances[0] > desired_distance*0.90 && Sim.distances[0] < desired_distance*1.10))
//Pr[<=300] ([] 1.0*t>= 100 imply (Sim.distances[1] > desired_distance*0.90 && Sim.distances[1] < desired_distance*1.10))
//Pr[<=300] ([] 1.0*t>= 100 imply (Sim.distances[2] > desired_distance*0.90 && Sim.distances[2] < desired_distance*1.10))

//Pr[<=300] ([] forall(i : int[1,3]) positions[i-1] - positions[i] >= 4)

E[<=300; 500] (max: (t>=100 ? 1.0 : 0.0)*fabs(Sim.distances[0])/desired_distance)
E[<=300; 500] (max: (t>=100 ? 1.0 : 0.0)*fabs(Sim.distances[1])/desired_distance)
E[<=300; 500] (max: (t>=100 ? 1.0 : 0.0)*fabs(Sim.distances[2])/desired_distance)

E[<=300; 500] (min: (t>=100 ? 1.0 : 1e800)*fabs(Sim.distances[0])/desired_distance)
E[<=300; 500] (min: (t>=100 ? 1.0 : 1e800)*fabs(Sim.distances[1])/desired_distance)
E[<=300; 500] (min: (t>=100 ? 1.0 : 1e800)*fabs(Sim.distances[2])/desired_distance)
