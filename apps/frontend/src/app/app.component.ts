import { ChangeDetectionStrategy, Component } from '@angular/core';
import { RouterOutlet } from '@angular/router';

@Component({
    selector: 'sh-root',
    standalone: true,
    imports: [RouterOutlet],
    changeDetection: ChangeDetectionStrategy.OnPush,
    template: `
        <main>
            <h1>Sentinel Hooks</h1>
            <p>Webhook gateway dashboard</p>
            <router-outlet />
        </main>
    `,
})
export class AppComponent {}
