import { ComponentFixture, TestBed } from '@angular/core/testing';

import { FormulaireSignalementComponent } from './formulaire-signalement.component';

describe('FormulaireSignalementComponent', () => {
  let component: FormulaireSignalementComponent;
  let fixture: ComponentFixture<FormulaireSignalementComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [FormulaireSignalementComponent]
    })
    .compileComponents();

    fixture = TestBed.createComponent(FormulaireSignalementComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
