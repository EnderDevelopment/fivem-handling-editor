Config = {}

Config.Command = 'handling'
Config.PermissionAce = 'handlingeditor.use'
Config.RequirePermission = true
Config.SaveFile = 'handling_overrides.json'
Config.MaxVehiclesPerPage = 100
Config.Fields = {
    { key = 'fMass', label = 'Mass', type = 'float', min = 100, max = 10000, step = 10, unit = 'kg' },
    { key = 'fInitialDragCoeff', label = 'Drag coefficient', type = 'float', min = 0, max = 100, step = 0.1 },
    { key = 'fDownforceModifier', label = 'Downforce', type = 'float', min = 0, max = 100, step = 0.1 },
    { key = 'fDriveBiasFront', label = 'Front drive bias', type = 'float', min = 0, max = 1, step = 0.01 },
    { key = 'nInitialDriveGears', label = 'Drive gears', type = 'int', min = 1, max = 10, step = 1 },
    { key = 'fInitialDriveForce', label = 'Drive force', type = 'float', min = 0, max = 5, step = 0.01 },
    { key = 'fDriveInertia', label = 'Drive inertia', type = 'float', min = 0, max = 5, step = 0.01 },
    { key = 'fClutchChangeRateScaleUpShift', label = 'Upshift rate', type = 'float', min = 0, max = 20, step = 0.1 },
    { key = 'fClutchChangeRateScaleDownShift', label = 'Downshift rate', type = 'float', min = 0, max = 20, step = 0.1 },
    { key = 'fInitialDriveMaxFlatVel', label = 'Top speed', type = 'float', min = 0, max = 1000, step = 1, unit = 'km/h' },
    { key = 'fBrakeForce', label = 'Brake force', type = 'float', min = 0, max = 5, step = 0.01 },
    { key = 'fBrakeBiasFront', label = 'Front brake bias', type = 'float', min = 0, max = 1, step = 0.01 },
    { key = 'fHandBrakeForce', label = 'Handbrake force', type = 'float', min = 0, max = 5, step = 0.01 },
    { key = 'fSteeringLock', label = 'Steering lock', type = 'float', min = 0, max = 90, step = 0.1 },
    { key = 'fTractionCurveMax', label = 'Traction max', type = 'float', min = 0, max = 10, step = 0.01 },
    { key = 'fTractionCurveMin', label = 'Traction min', type = 'float', min = 0, max = 10, step = 0.01 },
    { key = 'fTractionCurveLateral', label = 'Lateral traction', type = 'float', min = 0, max = 50, step = 0.1 },
    { key = 'fTractionSpringDeltaMax', label = 'Traction spring delta', type = 'float', min = 0, max = 5, step = 0.01 },
    { key = 'fLowSpeedTractionLossMult', label = 'Low speed traction loss', type = 'float', min = 0, max = 10, step = 0.01 },
    { key = 'fTractionLossMult', label = 'Traction loss', type = 'float', min = 0, max = 10, step = 0.01 },
    { key = 'fSuspensionForce', label = 'Suspension force', type = 'float', min = 0, max = 10, step = 0.01 },
    { key = 'fSuspensionCompDamp', label = 'Compression damping', type = 'float', min = 0, max = 10, step = 0.01 },
    { key = 'fSuspensionReboundDamp', label = 'Rebound damping', type = 'float', min = 0, max = 10, step = 0.01 },
    { key = 'fAntiRollBarForce', label = 'Anti-roll bar force', type = 'float', min = 0, max = 10, step = 0.01 },
    { key = 'fRollCentreHeightFront', label = 'Front roll centre', type = 'float', min = -2, max = 2, step = 0.01 },
    { key = 'fRollCentreHeightRear', label = 'Rear roll centre', type = 'float', min = -2, max = 2, step = 0.01 },
    { key = 'fCollisionDamageMult', label = 'Collision damage', type = 'float', min = 0, max = 10, step = 0.01 },
    { key = 'fDeformationDamageMult', label = 'Deformation damage', type = 'float', min = 0, max = 10, step = 0.01 },
    { key = 'fEngineDamageMult', label = 'Engine damage', type = 'float', min = 0, max = 10, step = 0.01 }
}
