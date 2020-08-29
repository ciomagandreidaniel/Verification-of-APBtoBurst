// _______________________________________________________ APB ASSERTIONS ___

  // Define the basics of a cycle
  //
  // A clock cycle in which nothing is happening...
  sequence APB_IDLE;
    !psel;
  endsequence

  // psel without PENABLE (first clock of cycle)
  sequence APB_PHASE_1;
    psel && !PENABLE;
  endsequence

  // psel with PENABLE (second clock of cycle)
  sequence APB_PHASE_2;
   psel && PENABLE;
  endsequence

  // A complete bus cycle
  sequence APB_CYCLE;
    APB_PHASE_1 ##1 APB_PHASE_2;
  endsequence

  // A read cycle
  sequence APB_READ_CYCLE;
    (!PWRITE) throughout APB_CYCLE;
  endsequence

  // A write cycle
  sequence APB_WRITE_CYCLE;
    PWRITE throughout APB_CYCLE;
  endsequence


  // Safety properties.  Note that some of these would be nicer
  // if we could write implications with a sequence as the antecedent.
  // Sadly VCS doesn't yet allow this.  See commented-out code.

  property APB_CYCLES_ARE_COMPLETE;
    // Once a cycle has started, it must complete
    //@(posedge PCLK) (APB_PHASE_1 |-> APB_CYCLE);
    @(posedge PCLK) ((psel && !PENABLE) |-> APB_CYCLE);
  endproperty

  property APB_NO_PENABLE_OUTSIDE_CYCLE2;
    // If we see PENABLE, it must be in the second clock of a cycle,
    // and it must then go away
    // ******* NB ********* Prefer to use APB_CYCLE.ended() instead of
    //                      $stable(psel), but it's not yet implemented
    @(posedge PCLK) (PENABLE |-> $stable(psel) ##1 (!PENABLE));
  endproperty

  property APB_WRITE_AND_ADDR_STABLE;
    // PWRITE and PADDR must be stable throughout the cycle
    //@(posedge PCLK) (APB_PHASE_2 |-> $stable({PWRITE, PADDR}));
    @(posedge PCLK) ((psel && PENABLE) |-> $stable({PWRITE, PADDR}));
  endproperty

  property APB_WRITE_AND_ADDR_VALID;
    // PWRITE and PADDR must be valid throughout the cycle (no X, Z)
    //@(posedge PCLK) (APB_PHASE_2 |-> ((!{PWRITE, PADDR}) !== 1'bx));
    @(posedge PCLK) ((psel && PENABLE) |-> ((!{PWRITE, PADDR}) !== 1'bx));
  endproperty

  property APB_WRITE_DATA_STABLE;
    // PWDATA must be stable throughout a write cycle
    @(posedge PCLK) ((PENABLE && PWRITE) |-> $stable(PWDATA));
  endproperty

  property APB_COMPLETE_CYCLES_WITH_VALID_ADDRESS;
    // PWRITE and PADDR must be valid throughout the cycle (no X, Z)
    // $isunknown isn't yet implemented, so use ((^A)===1'bx) instead
    @(posedge PCLK) ( (psel && !PENABLE) |->
                      ( ((^{PWRITE, PADDR}) !== 1'bx) throughout APB_CYCLE)
                    );
  endproperty


  // Assertions to check the safety properties

  cycles_complete   : assert property (APB_CYCLES_ARE_COMPLETE);
  PENABLE_valid     : assert property (APB_NO_PENABLE_OUTSIDE_CYCLE2);
  controls_stable   : assert property (APB_WRITE_AND_ADDR_STABLE);
  write_data_stable : assert property (APB_WRITE_DATA_STABLE);


  // Finally a few sequences to provide coverage points...

  // Two (or more) cycles back-to-back...
  sequence APB_BACK_TO_BACK;
    @(posedge PCLK) APB_CYCLE ##1 APB_CYCLE;
  endsequence

  // A bus cycle, preceded by an idle cycle...
  sequence APB_IDLE_THEN_CYCLE;
    @(posedge PCLK) APB_IDLE ##1 APB_CYCLE;
  endsequence


// __________________________________________________________________________
